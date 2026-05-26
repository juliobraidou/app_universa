const fs = require('fs');
const path = require('path');
const mysql = require('mysql2/promise');
require('dotenv').config({ path: path.join(__dirname, '..', '.env') });

async function run() {
  const file = process.argv[2];
  if (!file) {
    console.error('Uso: node scripts/run-sql.js <arquivo.sql>');
    process.exit(1);
  }

  const sqlPath = path.isAbsolute(file) ? file : path.join(__dirname, '..', file);
  const sql = fs.readFileSync(sqlPath, 'utf8');

  const connection = await mysql.createConnection({
    host: process.env.DB_HOST || 'localhost',
    port: Number(process.env.DB_PORT || 3306),
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    multipleStatements: true,
  });

  await connection.query(sql);
  await connection.end();
  console.log(`Executado: ${file}`);
}

run().catch((err) => {
  console.error(err.message);
  process.exit(1);
});
