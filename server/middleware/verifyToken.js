const jwt  = require('jsonwebtoken');

// in this step we basically extracted the user from our token and also checked its validity

const verifyToken = (req,res,next)=>{
    const authHeader = req.headers.authorization;
    if(authHeader){
        const token = authHeader.split(" ")[1];
        jwt.verify(token,process.env.JWT_SEC,(error,user)=>{
            if(error){
                res.status(401).json({
                    message : 'Invalid Token'
                })
            }
            req.user = user;
            next();
        })
    }
};


// now we will see if the user that we have extracted from the token is permitted or not and if not permitted
// then show a clear message that You Are Not Permitted to access
const verifyAdmin = (req,res,next)=>{
    verifyToken(req,res,()=>{
        if(req.user.id || req.user.isAdmin){
            next();
        }
        else{
            return res.status(403).json({
                message: 'You are not permitted to access'
            })
        }
    });
};

const verifyAgent  = (req,res,next)=>{
    verifyToken(req,res,()=>{
        if(req.user.id || req.user.isAgent){
            next();
        }else{
            return res.status(403).json({
                message : 'You are not authorized to access',
            });
        }
    });
};

module.exports = {
    verifyToken,
    verifyAgent,
    verifyAdmin,
}
