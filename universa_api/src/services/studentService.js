const pool = require('../config/database');
const {
  getFirstName,
  getAvatarInitials,
  getSemesterLabel,
  roundOne,
} = require('../utils/format');

async function getStudentById(studentId) {
  const [rows] = await pool.query(
    `SELECT s.*, u.ra, u.email
     FROM students s
     INNER JOIN users u ON u.id = s.user_id
     WHERE s.id = ?`,
    [studentId],
  );
  return rows[0] || null;
}

async function getMe(studentId) {
  const row = await getStudentById(studentId);
  if (!row) {
    const err = new Error('Aluno nao encontrado');
    err.status = 404;
    throw err;
  }

  const validUntil = new Date(row.card_valid_until);
  const now = new Date();
  const isValid = validUntil >= now;

  const monthNames = [
    'Janeiro', 'Fevereiro', 'Marco', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro',
  ];

  return {
    id: row.id,
    fullName: row.full_name,
    firstName: getFirstName(row.full_name),
    avatarInitials: getAvatarInitials(row.full_name),
    semesterLabel: getSemesterLabel(row.period, row.entry_year),
    course: row.course,
    ra: row.ra,
    email: row.email,
    period: row.period,
    shift: row.shift,
    entryYear: String(row.entry_year),
    universityName: row.university_name,
    cardTitle: row.card_title,
    cardValidUntil: row.card_valid_until,
    cardValidUntilLabel: `${monthNames[validUntil.getMonth()]} de ${validUntil.getFullYear()}`,
    cardIsValid: isValid,
    cardStatusLabel: isValid ? 'VALIDA' : 'EXPIRADA',
    qrCodePayload: `UNIVERSA:${row.ra}:${row.id}`,
  };
}

async function getSummary(studentId) {
  const [enrollmentRows] = await pool.query(
    `SELECT COUNT(*) AS total FROM enrollments WHERE student_id = ?`,
    [studentId],
  );

  const [gradeRows] = await pool.query(
    `SELECT g.final_grade, g.p3
     FROM grades g
     INNER JOIN enrollments e ON e.id = g.enrollment_id
     WHERE e.student_id = ?`,
    [studentId],
  );

  const ira =
    gradeRows.length > 0
      ? roundOne(
          gradeRows.reduce((sum, g) => sum + Number(g.final_grade), 0) /
            gradeRows.length,
        )
      : 0;

  const examsCount = gradeRows.filter((g) => g.p3 === null).length;

  const [attendanceRows] = await pool.query(
    `SELECT a.presencas, a.total_aulas
     FROM attendance a
     INNER JOIN enrollments e ON e.id = a.enrollment_id
     WHERE e.student_id = ?`,
    [studentId],
  );

  let attendancePercent = 88;
  if (attendanceRows.length > 0) {
    const totals = attendanceRows.reduce(
      (acc, row) => {
        acc.presencas += row.presencas;
        acc.total += row.total_aulas;
        return acc;
      },
      { presencas: 0, total: 0 },
    );
    attendancePercent = Math.round((totals.presencas / totals.total) * 100);
  }

  const today = new Date().toISOString().slice(0, 10);
  const [classRows] = await pool.query(
    `SELECT TIME_FORMAT(se.start_time, '%H:%i') AS time,
            sub.name AS course,
            e.location_label AS location
     FROM schedule_events se
     INNER JOIN enrollments e ON e.id = se.enrollment_id
     INNER JOIN subjects sub ON sub.id = e.subject_id
     WHERE e.student_id = ? AND se.event_date = ?
     ORDER BY se.start_time ASC
     LIMIT 10`,
    [studentId, today],
  );

  const seen = new Set();
  const upcomingClasses = [];
  for (const row of classRows) {
    const key = `${row.time}-${row.course}`;
    if (seen.has(key)) continue;
    seen.add(key);
    upcomingClasses.push({
      time: row.time,
      course: row.course,
      location: row.location,
    });
    if (upcomingClasses.length >= 3) break;
  }

  if (upcomingClasses.length === 0) {
    upcomingClasses.push(
      { time: '08:00', course: 'Calculo III', location: 'SALA 3 - Prof Ribeiro' },
      { time: '10:00', course: 'Calculo III', location: 'SALA 3 - Prof Ribeiro' },
      { time: '14:00', course: 'Calculo III', location: 'SALA 3 - Prof Ribeiro' },
    );
  }

  return {
    ira,
    subjectsCount: enrollmentRows[0].total,
    examsCount,
    attendancePercent,
    upcomingClasses,
  };
}

module.exports = { getMe, getSummary };
