const express =require('express');
const bookmarkController = require('../controllers/bookmarkController');
const router =  express.Router();
const {verifyToken,verifyAdmin,verifyAgent} = require('../middleware/verifyToken');


router.post('/',verifyAdmin,bookmarkController.createBookmark);
router.delete('/:id',verifyAdmin,bookmarkController.deleteBookmark);
router.get('/',verifyAdmin,bookmarkController.getAllBookmarks);
router.get('/bookmark/:id',verifyAdmin,bookmarkController.getBookmark);

module.exports = router;