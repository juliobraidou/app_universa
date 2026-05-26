const { Router } = require('express');
const authController = require('../controllers/authController');
const { loginLimiter } = require('../middlewares/rateLimiters');

const router = Router();

router.post('/login', loginLimiter, authController.login);

module.exports = router;
