const admin = require('firebase-admin');
const jwt = require('jsonwebtoken');
const cryptojs = require('crypto-js');
const User = require('../models/user');

module.exports = {
    createUser: async (req, res) => {
        const userData = req.body;
        /*   ----------- Flow for createUser endpoint------------------------
           first of all we will get the user from our request body
           then we will check if the user is already present in our database
           if the user exists then we will return json with the message "user already exists"
           if the user is not found then only we will proceed with creating the user
           by using firebase we will create the user then also save that user in our mongoose database
         */

        if (!userData.email || !userData.password || !userData.username) {
            return res.status(400).json({
                status: false,
                message: 'Email, password and username are required'
            });
        }

        try {
            await admin.auth().getUserByEmail(userData.email);
            return res.status(409).json({
                status: false,
                message: 'User already exists'
            });
        } catch (error) {
            if (error.code !== 'auth/user-not-found') {
                return res.status(500).json({
                    status: false,
                    message: 'Firebase authentication error',
                    error: error.message
                });
            }

            try {
                const userResponse = await admin.auth().createUser({
                    email: userData.email,
                    emailVerified: false,
                    password: userData.password,
                });

                const newUser = new User({
                    username: userData.username,
                    uid: userResponse.uid,
                    email: userData.email,
                    password: cryptojs.AES.encrypt(
                        userData.password, 
                        process.env.SECRET
                    ).toString(),
                    location: userData.location || '',
                    phone: userData.phone || '',
                });
                await newUser.save();
                return res.status(201).json({
                    status: true,
                    message: 'User created successfully'
                });
            } catch (error) {
                console.error('User creation error:', error);
                return res.status(500).json({
                    status: false,
                    message: 'Error occurred while creating the user',
                    error: error.message
                });
            }
        }
    },

    loginUser: async (req, res) => {
        try {
            if (!req.body.email || !req.body.password) {
                return res.status(400).json({
                    status: false,
                    message: 'Email and password are required'
                });
            }
            /*
             *                     Pseudo Code
             * const user  = await User.findOne({email: req.body.email});
             * now we have our user now is the time to decrpt the password for the user
             * const passworddecycpted = cryptojs.AES.decrypt(user.password, process.env.SECRET)
             * const finalpassword = passworddecypted.toString(cryptojs.enc.utf)
             */
            const user = await User.findOne({ email: req.body.email });
            if (!user) {
                return res.status(404).json({
                    status: false,
                    message: 'User does not exist, please register first'
                });
            }

            // Decrypt password from database
            const passwordDecrypted = cryptojs.AES.decrypt(
                user.password,
                process.env.SECRET
            );
            const decryptedPassword = passwordDecrypted.toString(cryptojs.enc.Utf8);
            // here only the toString() would not be enough as it will provide us with the row hex or garbage characters only
            // thats why we need to specify the encoding method for getting the password correctly
            
            // Compare with provided password
            if (decryptedPassword !== req.body.password) {
                return res.status(401).json({
                    status: false,
                    message: 'Invalid password'
                });
            }
            // providing a jwt signed token for the user
            // userId = req.user.id;
            const userToken = jwt.sign({
                id: user._id,  // mongoose db id for the database
                isAdmin: user.isAdmin,
                isAgent: user.isAgent,
                uid: user.uid
            }, process.env.JWT_SEC, { expiresIn: '21d' });

            const { password, isAdmin, ...userDetails } = user._doc;
            
            return res.status(200).json({
                status: true,
                user: userDetails,
               userToken
            });
        } catch (error) {
            console.error('Login error:', error);
            return res.status(500).json({
                status: false,
                message: 'Error logging in to the application',
                error: error.message
            });
        }
    },

    getUser: async (req, res) => {
        try {
            if (req.params.id) {
                const user = await User.findById(req.params.id);
                if (!user) {
                    return res.status(404).json({
                        status: false,
                        message: 'User not found'
                    });
                }
                const { password, ...userDetails } = user._doc;
                
                return res.status(200).json({
                    status: true,
                    user: userDetails
                });
            } else {
                const page = parseInt(req.query.page) || 1;
                const limit = parseInt(req.query.limit) || 10;
                const skip = (page - 1) * limit;
                
                const users = await User.find()
                    .select('-password') // Exclude password field
                    .skip(skip)
                    .limit(limit);
                    
                const totalUsers = await User.countDocuments();
                
                return res.status(200).json({
                    status: true,
                    count: users.length,
                    total: totalUsers,
                    totalPages: Math.ceil(totalUsers / limit),
                    currentPage: page,
                    users
                });
            }
        } catch (error) {
            console.error('Get user error:', error);
            return res.status(500).json({
                status: false,
                message: 'Error retrieving users',
                error: error.message
            });
        }
    }
};