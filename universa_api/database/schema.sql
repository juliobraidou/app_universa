-- Universa API - Schema
-- Execute no MySQL Workbench (ou: mysql -u root -p < database/schema.sql)

CREATE DATABASE IF NOT EXISTS universa
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE universa;

DROP TABLE IF EXISTS schedule_events;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS grades;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS subjects;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(120) NOT NULL,
  ra VARCHAR(20) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_users_email (email),
  UNIQUE KEY uk_users_ra (ra)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE students (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  full_name VARCHAR(120) NOT NULL,
  course VARCHAR(120) NOT NULL,
  period VARCHAR(20) NOT NULL,
  shift VARCHAR(40) NOT NULL,
  entry_year INT NOT NULL,
  university_name VARCHAR(120) NOT NULL DEFAULT 'Universidade Federal',
  card_title VARCHAR(80) NOT NULL DEFAULT 'Carteira de Estudante',
  card_valid_until DATE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_students_user (user_id),
  CONSTRAINT fk_students_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE subjects (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  professor VARCHAR(80) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE enrollments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT NOT NULL,
  subject_id INT NOT NULL,
  location_label VARCHAR(120) NOT NULL DEFAULT 'SALA 3 - Prof Ribeiro',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_enrollments_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  CONSTRAINT fk_enrollments_subject FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE grades (
  enrollment_id INT PRIMARY KEY,
  p1 DECIMAL(4,2) NULL,
  p2 DECIMAL(4,2) NULL,
  p3 DECIMAL(4,2) NULL,
  final_grade DECIMAL(4,2) NOT NULL,
  CONSTRAINT fk_grades_enrollment FOREIGN KEY (enrollment_id) REFERENCES enrollments(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE attendance (
  enrollment_id INT PRIMARY KEY,
  presencas INT NOT NULL,
  faltas INT NOT NULL,
  total_aulas INT NOT NULL,
  CONSTRAINT fk_attendance_enrollment FOREIGN KEY (enrollment_id) REFERENCES enrollments(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE schedule_events (
  id INT AUTO_INCREMENT PRIMARY KEY,
  enrollment_id INT NOT NULL,
  event_date DATE NOT NULL,
  start_time TIME NOT NULL,
  duration_minutes INT NOT NULL DEFAULT 120,
  room VARCHAR(60) NOT NULL,
  theme_key VARCHAR(20) NOT NULL DEFAULT 'purple',
  CONSTRAINT fk_schedule_enrollment FOREIGN KEY (enrollment_id) REFERENCES enrollments(id) ON DELETE CASCADE,
  INDEX idx_schedule_date (event_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
