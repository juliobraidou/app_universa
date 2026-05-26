const jwt = require('jsonwebtoken');
const pool = require('../config/database');

async function authMiddleware(req, res, next) {
  const header = req.headers.authorization;
  if (!header || !header.startsWith('Bearer ')) {
    return res.status(401).json({ message: 'Token nao informado' });
  }

  const token = header.slice(7);
  try {
    const payload = jwt.verify(token, process.env.JWT_SECRET);

    const [rows] = await pool.query(
      'SELECT id FROM students WHERE id = ? AND user_id = ? LIMIT 1',
      [payload.studentId, payload.userId],
    );

    if (rows.length === 0) {
      return res.status(401).json({ message: 'Sessao invalida' });
    }

    req.userId = payload.userId;
    req.studentId = payload.studentId;
    next();
  } catch {
    return res.status(401).json({ message: 'Token invalido ou expirado' });
  }
}

module.exports = authMiddleware;
