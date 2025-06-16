const router = require('express').Router();

const jobController  = require('../controllers/jobController');
const {verifyToken , verifyAgent} = require('../middleware/verifyToken');

router.post('/',verifyAgent,jobController.createJob);
 
router.put('/:id',verifyAgent,jobController.updateJob); /// for updating we use put

router.get('/search/:key',jobController.searchJobs);    

router.delete('/:id',verifyAgent,jobController.deleteJob); // for deleting we use delete

router.get('/:id',jobController.getJob); // we are not doing anything just updating means simple get would suffice

router.get('/',jobController.getAllJobs); // same with get all the jobs we are not doing anything just getting all the jobs

router.get('/agent/:uid',jobController.getAgentJobs);

module.exports = router;

/* 
update  - put, delete  - delete , get/show/fetch - get , to post some data to the server  - post
create a job means posting a job means - post
get a particular job or all the jobs  -  get
updates  - put means putting some data to its place
delete - delete a document/  collection / data etc
*/