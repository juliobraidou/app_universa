const pool = require('../config/database');
const { formatTime, formatDuration } = require('../utils/format');

async function getScheduleByDate(studentId, date) {
  const [rows] = await pool.query(
    `SELECT TIME_FORMAT(se.start_time, '%H:%i') AS time,
            sub.name AS subject,
            se.room,
            se.duration_minutes,
            se.theme_key AS themeKey
     FROM schedule_events se
     INNER JOIN enrollments e ON e.id = se.enrollment_id
     INNER JOIN subjects sub ON sub.id = e.subject_id
     WHERE e.student_id = ? AND se.event_date = ?
     ORDER BY se.start_time ASC`,
    [studentId, date],
  );

  const seen = new Set();
  const events = [];

  for (const row of rows) {
    const key = `${row.time}-${row.subject}-${row.room}`;
    if (seen.has(key)) continue;
    seen.add(key);
    events.push({
      time: row.time,
      subject: row.subject,
      room: row.room,
      duration: formatDuration(row.duration_minutes),
      themeKey: row.themeKey,
    });
  }

  return events;
}

async function getTodaySchedule(studentId) {
  const today = new Date().toISOString().slice(0, 10);
  return getScheduleByDate(studentId, today);
}

module.exports = { getScheduleByDate, getTodaySchedule };
