const mongoose = require('mongoose');

const JobScheme = new mongoose.Schema({
    title: {type: String , required: true},
    location: {type: String, required : true},
    description: {type:String, requried:true},
    agentName: {type:String,required:true},
    salary : {type: String,required :true},
    company: {type:String,requried: true},
    period:{type: String,required:true},
    contact: {type: String, required:false},
    hiring:{type:String, required: true},
    requirements : {
        type: Array, required: true
    },
    imageUrl :{type: String, required: true},
    agentId: {type: String, required: true},
},{timestamps:true})

module.exports = mongoose.model('Job',JobScheme);