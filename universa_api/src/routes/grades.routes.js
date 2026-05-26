const { Router } = require('express');
const auth = require('../middlewares/auth');
const gradesController = require('../controllers/gradesController');

const router = Router();

router.get('/', auth, gradesController.list);

module.exports = router;
