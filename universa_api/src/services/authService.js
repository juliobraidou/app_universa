const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const pool = require('../config/database');
const {
  getFirstName,
  getAvatarInitials,
  getSemesterLabel,
} = require('../utils/format');

async function findUserByLogin(login) {
  const [rows] = await pool.query(
    `SELECT u.id AS user_id, u.password_hash,
            s.id AS student_id, s.full_name, s.course, s.period, s.entry_year, u.ra
     FROM users u
     INNER JOIN students s ON s.user_id = u.id
     WHERE u.email = ? OR u.ra = ?`,
    [login, login],
  );
  return rows[0] || null;
}

async function login(login, password) {
  const row = await findUserByLogin(login);
  if (!row) {
    const err = new Error('Credenciais invalidas');
    err.status = 401;
    throw err;
  }

  const valid = await bcrypt.compare(password, row.password_hash);
  if (!valid) {
    const err = new Error('Credenciais invalidas');
    err.status = 401;
    throw err;
  }

  const token = jwt.sign(
    { userId: row.user_id, studentId: row.student_id },
    process.env.JWT_SECRET,
    { expiresIn: process.env.JWT_EXPIRES_IN || '7d' },
  );

  return {
    token,
    student: {
      id: row.student_id,
      fullName: row.full_name,
      firstName: getFirstName(row.full_name),
      avatarInitials: getAvatarInitials(row.full_name),
      semesterLabel: getSemesterLabel(row.period, row.entry_year),
      course: row.course,
      ra: row.ra,
    },
  };
}

module.exports = { login };
