const { Router } = require('express');
const auth = require('../middlewares/auth');
const attendanceController = require('../controllers/attendanceController');

const router = Router();

router.get('/', auth, attendanceController.list);

module.exports = router;
