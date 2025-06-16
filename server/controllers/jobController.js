const JobScheme = require('../models/job');

module.exports = {
    createJob :  async (req,res)=>{
        const newJob = new JobScheme(req.body);
        try{
            await newJob.save();
            res.status(201).json({status:true,message: 'Job Created Succesfully'}); 
        }catch(error){
            res.status(501).json({status: false,message: error});
        }
        
    },
    updateJob: async (req, res) => {
        const jobId = req.params.id;
        const JobToUpdate = req.body;
        
        try {
            const updatedJob = await JobScheme.findByIdAndUpdate(
                jobId, 
                JobToUpdate, 
                { new: true }
            );
            if (!updatedJob) {
                return res.status(404).json({
                    message: 'Job Not Found',
                    status: false
                });
            }
            res.status(200).json({
                message: 'Job Updated Successfully',
                status: true,
                data: updatedJob
            });
        } catch (error) {
            res.status(500).json({
                status: false,
                message: 'Failed to update job',
                error: error.message
            });
        }
    },
    
    deleteJob : async (req,res)=>{
        const jobId = req.params.id;
        try {
            await JobScheme.findByIdAndDelete(jobId),
            res.status(202).json({status:true,message : 'Job Deleted Succesfullly'});
        } catch (error) {
            res.status(501).json(error);
        }
    },

    getJob: async (req, res) => {
        const jobId = req.params.id;
        try {
            const job = await JobScheme.findById(jobId, {
                createdAt: 0,
                updatedAt: 0,
                __v: 0
            });
            
            if (!job) {
                return res.status(404).json({
                    status: false,
                    message: 'Job not found'
                });
            }
            res.status(200).json({
                status: true,
                data: job
            });
        } catch (error) {
            res.status(500).json({
                status: false,
                message: 'Failed to get job',
                error: error.message
            });
        }
    },

    getAllJobs : async(req,res)=>{
        const recent  =  req.query.new;
        try{
            let jobs;
            if(recent){
                jobs = await JobScheme.find({},{createdAt : 0, updatedAt:0,__V : 0}).sort({createdAt : -1});
            }else{
                jobs = await JobScheme.find({},{createdAt: 0, updatedAt: 0,__V : 0});
            } 
            res.status(200).json(jobs);
        }catch(error){ 
              res.status(500).json(error);
        }
    },
    searchJobs : async(req,res)=>{
        try {
            const results = await JobScheme.aggregate([
  {
    $search: {
      index: "joblook_search",
      text: {
        query: req.params.key,
        path: {
          wildcard: "*"
        }
      }
    }
  }
            ]);
            res.status(200).json(results);
        } catch (error) {
            res.status(500).json({status:true, message: 'Failed to search Jobs'});
        }
    },
    getAgentJobs: async (req, res) => {
    const agentUid = req.params.uid;
    try {
      const agentJobs = await Job.find(
        { agentId: agentUid },   
        {
          createdAt: 0,
          updatedAt: 0,
          __v: 0,
        }
      ).sort({ createdAt: -1 });

      return res.status(200).json(agentJobs);
    } catch (error) {
      return res.status(500).json({
        error: error.message,
      })
    }
  },
}