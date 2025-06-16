const mongoose  =require('mongoose');


const agentScheme= mongoose.Schema({
    userId: {type: String, required: true},
    uid: {type:String , required:true},
    hq_address: { type: String , required: true},
    company: {type:String, required : true},
    working_hrs : {type:String, required: true}
});

module.exports  = mongoose.model('agent',agentScheme);