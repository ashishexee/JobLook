const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const { verifyToken } = require('../middleware/verifyToken');

router.get('/' , verifyToken , userController.getUser);

router.put('/update' , verifyToken , userController.updateUser);

router.delete('/delete',verifyToken, userController.deleteUser);

router.post('/skills' , verifyToken , userController.addSkill);

router.get('/skills',verifyToken,userController.getSkills);

router.delete('/skills/:id' , verifyToken , userController.deleteSkill);

router.post('/agents' , verifyToken , userController.addAgent);

router.put('/agents/:id' , verifyToken , userController.updateAgent);

router.get('/agents/:uid' , verifyToken , userController.getAgent);

router.get('/agents' , verifyToken , userController.getAllAgents);


module.exports  = router;