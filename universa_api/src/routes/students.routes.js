const { Router } = require('express');
const auth = require('../middlewares/auth');
const studentController = require('../controllers/studentController');

const router = Router();

router.get('/me', auth, studentController.getMe);
router.get('/me/summary', auth, studentController.getSummary);

module.exports = router;
