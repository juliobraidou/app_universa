const { z } = require('zod');
const authService = require('../services/authService');

const loginSchema = z.object({
  login: z.string().min(1, 'Login obrigatorio'),
  password: z.string().min(1, 'Senha obrigatoria'),
});

async function login(req, res, next) {
  try {
    const parsed = loginSchema.safeParse(req.body);
    if (!parsed.success) {
      return res.status(400).json({
        message: parsed.error.errors[0]?.message || 'Dados invalidos',
      });
    }

    const result = await authService.login(
      parsed.data.login.trim(),
      parsed.data.password,
    );
    res.json(result);
  } catch (err) {
    next(err);
  }
}

module.exports = { login };
