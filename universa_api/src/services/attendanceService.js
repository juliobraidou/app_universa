const pool = require('../config/database');
const { getAttendanceStatus } = require('../utils/format');

async function getAttendance(studentId) {
  const [rows] = await pool.query(
    `SELECT sub.name AS subject, sub.professor,
            a.presencas, a.faltas, a.total_aulas
     FROM attendance a
     INNER JOIN enrollments e ON e.id = a.enrollment_id
     INNER JOIN subjects sub ON sub.id = e.subject_id
     WHERE e.student_id = ?
     ORDER BY sub.name ASC, a.enrollment_id ASC`,
    [studentId],
  );

  return rows.map((row) => {
    const percent = Math.round((row.presencas / row.total_aulas) * 100);
    return {
      subject: row.subject,
      professor: row.professor,
      percent,
      status: getAttendanceStatus(percent),
      presencas: row.presencas,
      faltas: row.faltas,
      aulas: row.total_aulas,
    };
  });
}

module.exports = { getAttendance };
