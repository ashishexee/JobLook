const mongoose = require('mongoose');
const UserSchema = new mongoose.Schema({
    username: {type: String, required: true, unique: true},
    email: {type: String, required: true, unique: true},
    password: {type: String, required: true},
    uid : {type:String , required: true},
    location: {type: String, required: false},
    phone: {type: String, required: false},
    updated: {type: Boolean, default: false},
    isAdmin: {type: Boolean, default: false},
    isAgent: {type: Boolean, default: false},
    skills: {type: Boolean, default: false, required: false},
    profile: {
        type: String, 
        required: true, 
        default: "https://static.vecteezy.com/system/resources/previews/009/292/244/non_2x/default-avatar-icon-of-social-media-user-vector.jpg"
    }
}, {timestamps: true});

module.exports = mongoose.model('User', UserSchema);