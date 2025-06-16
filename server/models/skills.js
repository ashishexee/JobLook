const mongoose = require('mongoose');

const skillScheme = mongoose.Schema({
    skill : {type:String , required : true},
    userId : {type :
        String , required : true}
});


module.exports = mongoose.model('Skill' , skillScheme);
