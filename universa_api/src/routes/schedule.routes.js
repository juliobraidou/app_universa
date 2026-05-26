const { Router } = require('express');
const auth = require('../middlewares/auth');
const scheduleController = require('../controllers/scheduleController');

const router = Router();

router.get('/today', auth, scheduleController.today);
router.get('/', auth, scheduleController.listByDate);

module.exports = router;
