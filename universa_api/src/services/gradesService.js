const pool = require('../config/database');

async function getGrades(studentId) {
  const [rows] = await pool.query(
    `SELECT sub.name AS subject, sub.professor,
            g.p1, g.p2, g.p3, g.final_grade
     FROM grades g
     INNER JOIN enrollments e ON e.id = g.enrollment_id
     INNER JOIN subjects sub ON sub.id = e.subject_id
     WHERE e.student_id = ?
     ORDER BY sub.name ASC, g.enrollment_id ASC`,
    [studentId],
  );

  return rows.map((row) => ({
    subject: row.subject,
    professor: row.professor,
    finalGrade: Number(row.final_grade),
    exams: [
      { label: 'P1', value: row.p1 !== null ? Number(row.p1) : null },
      { label: 'P2', value: row.p2 !== null ? Number(row.p2) : null },
      { label: 'P3', value: row.p3 !== null ? Number(row.p3) : null },
    ],
  }));
}

module.exports = { getGrades };
