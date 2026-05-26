const path = require('path');
const bcrypt = require('bcryptjs');
const mysql = require('mysql2/promise');
require('dotenv').config({ path: path.join(__dirname, '..', '.env') });

/** @typedef {{ name: string, professor: string, location: string, grade: object, attendance: object }} SubjectSeed */

const SUBJECTS = /** @type {SubjectSeed[]} */ ([
  {
    name: 'Calculo III',
    professor: 'Prof Ribeiro',
    location: 'SALA 301 - Bloco B',
    grade: { p1: 8.0, p2: 7.5, p3: null, final_grade: 7.9 },
    attendance: { presencas: 65, faltas: 15, total_aulas: 80 },
  },
  {
    name: 'Calculo III',
    professor: 'Prof Ribeiro',
    location: 'SALA 302 - Bloco B',
    grade: { p1: 5.0, p2: 6.2, p3: null, final_grade: 5.9 },
    attendance: { presencas: 58, faltas: 22, total_aulas: 80 },
  },
  {
    name: 'Calculo III',
    professor: 'Prof Ribeiro',
    location: 'SALA 303 - Bloco B',
    grade: { p1: 8.5, p2: 8.0, p3: 7.8, final_grade: 8.2 },
    attendance: { presencas: 40, faltas: 40, total_aulas: 80 },
  },
  {
    name: 'Algoritmos',
    professor: 'Prof Silva',
    location: 'LAB 12 - Centro de Informatica',
    grade: { p1: 7.0, p2: 7.2, p3: 7.1, final_grade: 7.1 },
    attendance: { presencas: 76, faltas: 4, total_aulas: 80 },
  },
  {
    name: 'Banco de Dados',
    professor: 'Prof Costa',
    location: 'SALA 204 - Prof Costa',
    grade: { p1: 6.5, p2: 7.0, p3: null, final_grade: 6.8 },
    attendance: { presencas: 74, faltas: 6, total_aulas: 80 },
  },
  {
    name: 'Engenharia de Software',
    professor: 'Prof Lima',
    location: 'SALA 105 - Prof Lima',
    grade: { p1: 8.0, p2: 8.5, p3: null, final_grade: 8.3 },
    attendance: { presencas: 72, faltas: 8, total_aulas: 80 },
  },
  {
    name: 'Redes de Computadores',
    professor: 'Prof Alves',
    location: 'LAB Redes - Bloco C',
    grade: { p1: 9.0, p2: 8.8, p3: 9.2, final_grade: 9.0 },
    attendance: { presencas: 78, faltas: 2, total_aulas: 80 },
  },
  {
    name: 'Sistemas Operacionais',
    professor: 'Prof Mendes',
    location: 'SALA 410 - Prof Mendes',
    grade: { p1: 6.0, p2: 6.8, p3: null, final_grade: 6.4 },
    attendance: { presencas: 68, faltas: 12, total_aulas: 80 },
  },
  {
    name: 'Inteligencia Artificial',
    professor: 'Prof Martins',
    location: 'LAB IA - Bloco D',
    grade: { p1: 7.5, p2: 8.0, p3: null, final_grade: 7.8 },
    attendance: { presencas: 70, faltas: 10, total_aulas: 80 },
  },
  {
    name: 'Compiladores',
    professor: 'Prof Souza',
    location: 'SALA 215 - Prof Souza',
    grade: { p1: 5.5, p2: 6.0, p3: 5.8, final_grade: 5.8 },
    attendance: { presencas: 55, faltas: 25, total_aulas: 80 },
  },
]);

/**
 * Grade semanal por dia (1=seg … 5=sex).
 * enrollmentIndex referencia SUBJECTS / matriculas na mesma ordem.
 */
const WEEKLY_SCHEDULE = {
  1: [
    { enrollmentIndex: 0, time: '08:00:00', room: 'Sala B204', duration: 120, theme: 'purple' },
    { enrollmentIndex: 3, time: '10:30:00', room: 'LAB 12', duration: 120, theme: 'olive' },
    { enrollmentIndex: 4, time: '14:00:00', room: 'Sala 204', duration: 120, theme: 'brown' },
    { enrollmentIndex: 6, time: '19:00:00', room: 'LAB Redes', duration: 120, theme: 'magenta' },
  ],
  2: [
    { enrollmentIndex: 1, time: '08:00:00', room: 'Sala B204', duration: 120, theme: 'purple' },
    { enrollmentIndex: 5, time: '10:30:00', room: 'Sala 105', duration: 120, theme: 'olive' },
    { enrollmentIndex: 7, time: '14:00:00', room: 'Sala 410', duration: 120, theme: 'brown' },
    { enrollmentIndex: 8, time: '19:30:00', room: 'LAB IA', duration: 120, theme: 'magenta' },
  ],
  3: [
    { enrollmentIndex: 2, time: '08:00:00', room: 'Sala B204', duration: 120, theme: 'purple' },
    { enrollmentIndex: 4, time: '10:30:00', room: 'Sala 204', duration: 120, theme: 'olive' },
    { enrollmentIndex: 6, time: '14:00:00', room: 'LAB Redes', duration: 120, theme: 'brown' },
    { enrollmentIndex: 9, time: '19:00:00', room: 'Sala 215', duration: 120, theme: 'magenta' },
  ],
  4: [
    { enrollmentIndex: 0, time: '10:00:00', room: 'SALA 3 - Prof Ribeiro', duration: 120, theme: 'purple' },
    { enrollmentIndex: 3, time: '14:00:00', room: 'LAB 12', duration: 120, theme: 'olive' },
    { enrollmentIndex: 5, time: '19:00:00', room: 'Sala 105', duration: 120, theme: 'brown' },
  ],
  5: [
    { enrollmentIndex: 1, time: '08:00:00', room: 'Sala B204', duration: 120, theme: 'purple' },
    { enrollmentIndex: 7, time: '10:30:00', room: 'Sala 410', duration: 120, theme: 'olive' },
    { enrollmentIndex: 8, time: '14:00:00', room: 'LAB IA', duration: 120, theme: 'brown' },
    { enrollmentIndex: 9, time: '16:30:00', room: 'Sala 215', duration: 120, theme: 'magenta' },
  ],
};

function formatDate(d) {
  const y = d.getFullYear();
  const m = String(d.getMonth() + 1).padStart(2, '0');
  const day = String(d.getDate()).padStart(2, '0');
  return `${y}-${m}-${day}`;
}

async function run() {
  const pool = mysql.createPool({
    host: process.env.DB_HOST || 'localhost',
    port: Number(process.env.DB_PORT || 3306),
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'universa',
    multipleStatements: true,
  });

  const passwordHash = await bcrypt.hash('123456', 10);

  await pool.query('SET FOREIGN_KEY_CHECKS = 0');
  await pool.query('TRUNCATE TABLE schedule_events');
  await pool.query('TRUNCATE TABLE attendance');
  await pool.query('TRUNCATE TABLE grades');
  await pool.query('TRUNCATE TABLE enrollments');
  await pool.query('TRUNCATE TABLE subjects');
  await pool.query('TRUNCATE TABLE students');
  await pool.query('TRUNCATE TABLE users');
  await pool.query('SET FOREIGN_KEY_CHECKS = 1');

  const [userResult] = await pool.query(
    `INSERT INTO users (email, ra, password_hash) VALUES (?, ?, ?)`,
    ['ra@universidade.edu.br', '20260000', passwordHash],
  );

  const [studentResult] = await pool.query(
    `INSERT INTO students
      (user_id, full_name, course, period, shift, entry_year, university_name, card_valid_until)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
    [
      userResult.insertId,
      'Natalia Moreira',
      'CIENCIA DA COMPUTAÇÃO',
      '1º',
      'Noturno',
      2026,
      'Universidade Federal',
      '2026-06-30',
    ],
  );
  const studentId = studentResult.insertId;

  const enrollmentIds = [];

  for (const subject of SUBJECTS) {
    const [subjectResult] = await pool.query(
      'INSERT INTO subjects (name, professor) VALUES (?, ?)',
      [subject.name, subject.professor],
    );

    const [enrollmentResult] = await pool.query(
      'INSERT INTO enrollments (student_id, subject_id, location_label) VALUES (?, ?, ?)',
      [studentId, subjectResult.insertId, subject.location],
    );
    const enrollmentId = enrollmentResult.insertId;
    enrollmentIds.push(enrollmentId);

    const g = subject.grade;
    await pool.query(
      `INSERT INTO grades (enrollment_id, p1, p2, p3, final_grade) VALUES (?, ?, ?, ?, ?)`,
      [enrollmentId, g.p1, g.p2, g.p3, g.final_grade],
    );

    const a = subject.attendance;
    await pool.query(
      `INSERT INTO attendance (enrollment_id, presencas, faltas, total_aulas) VALUES (?, ?, ?, ?)`,
      [enrollmentId, a.presencas, a.faltas, a.total_aulas],
    );
  }

  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const todayStr = formatDate(today);

  // Proximas 6 semanas (dias uteis), aulas diferentes por dia da semana
  for (let dayOffset = -7; dayOffset < 42; dayOffset++) {
    const d = new Date(today);
    d.setDate(d.getDate() + dayOffset);
    const dow = d.getDay();
    if (dow === 0 || dow === 6) continue;

    const dayPlan = WEEKLY_SCHEDULE[dow];
    if (!dayPlan) continue;

    const dateStr = formatDate(d);

    for (const slot of dayPlan) {
      const enrollmentId = enrollmentIds[slot.enrollmentIndex];
      await pool.query(
        `INSERT INTO schedule_events
          (enrollment_id, event_date, start_time, duration_minutes, room, theme_key)
         VALUES (?, ?, ?, ?, ?, ?)`,
        [
          enrollmentId,
          dateStr,
          slot.time,
          slot.duration,
          slot.room,
          slot.theme,
        ],
      );
    }
  }

  // Dashboard: 3 proximas aulas de Calculo hoje (horarios do mock)
  const dashboardSlots = [
    { time: '08:00:00', location: 'SALA 3 - Prof Ribeiro' },
    { time: '10:00:00', location: 'SALA 3 - Prof Ribeiro' },
    { time: '14:00:00', location: 'SALA 3 - Prof Ribeiro' },
  ];

  const todayDow = today.getDay();
  if (todayDow !== 0 && todayDow !== 6) {
    for (const slot of dashboardSlots) {
      await pool.query(
        `INSERT INTO schedule_events
          (enrollment_id, event_date, start_time, duration_minutes, room, theme_key)
         VALUES (?, ?, ?, 120, ?, 'purple')`,
        [enrollmentIds[0], todayStr, slot.time, slot.location],
      );
    }
  }

  await pool.end();

  console.log('Seed concluido com sucesso.');
  console.log(`- ${SUBJECTS.length} materias matriculadas`);
  console.log('- Agenda com aulas distintas por dia da semana (6 semanas)');
  console.log('Login: ra@universidade.edu.br / 123456');
  console.log('RA: 20260000 / 123456');
}

run().catch((err) => {
  console.error(err);
  process.exit(1);
});
