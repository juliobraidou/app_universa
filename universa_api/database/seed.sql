-- Universa API - Seed (dados espelhando o app Flutter)
-- Senha do usuario: 123456 (hash aplicado pelo script run-seed.js)
-- Este arquivo insere dados apos o usuario ser criado pelo script.

USE universa;

-- subjects (6 matérias para contagem do dashboard)
INSERT INTO subjects (id, name, professor) VALUES
  (1, 'Calculo III', 'Prof Ribeiro'),
  (2, 'Algoritmos', 'Prof Silva'),
  (3, 'Banco de Dados', 'Prof Costa'),
  (4, 'Engenharia de Software', 'Prof Lima'),
  (5, 'Redes de Computadores', 'Prof Alves'),
  (6, 'Sistemas Operacionais', 'Prof Mendes');

-- enrollments 1-3: notas/frequencia do mock (Calculo III)
-- enrollments 4-6: extras para subjectsCount = 6
-- (student_id e user serao vinculados pelo run-seed.js se necessario)
