const http = require('http');

const base = 'http://localhost:3000';

function req(method, path, body, headers = {}) {
  return new Promise((resolve, reject) => {
    const u = new URL(path, base);
    const data = body ? JSON.stringify(body) : null;
    const opts = {
      hostname: u.hostname,
      port: u.port,
      path: u.pathname + u.search,
      method,
      headers: { 'Content-Type': 'application/json', ...headers },
    };
    if (data) opts.headers['Content-Length'] = Buffer.byteLength(data);
    const r = http.request(opts, (res) => {
      let b = '';
      res.on('data', (c) => (b += c));
      res.on('end', () => resolve({ status: res.statusCode, body: b }));
    });
    r.on('error', reject);
    if (data) r.write(data);
    r.end();
  });
}

async function floodLogin(n) {
  const start = Date.now();
  const results = await Promise.all(
    Array.from({ length: n }, () =>
      req('POST', '/api/auth/login', {
        login: 'ra@universidade.edu.br',
        password: 'wrong',
      }),
    ),
  );
  const elapsed = Date.now() - start;
  const statuses = results.reduce((acc, r) => {
    acc[r.status] = (acc[r.status] || 0) + 1;
    return acc;
  }, {});
  return { n, elapsed, statuses };
}

async function main() {
  console.log('=== 1. Rotas protegidas sem token ===');
  for (const p of [
    '/api/students/me',
    '/api/grades',
    '/api/schedule?date=2026-05-22',
  ]) {
    const r = await req('GET', p);
    console.log(p, '->', r.status);
  }

  console.log('\n=== 2. Token invalido ===');
  const fake = await req('GET', '/api/grades', null, {
    Authorization: 'Bearer ey.invalid.token',
  });
  console.log('/api/grades fake JWT ->', fake.status);

  console.log('\n=== 3. SQL injection login ===');
  const sqli = await req('POST', '/api/auth/login', {
    login: "' OR '1'='1' --",
    password: 'x',
  });
  console.log('login payload ->', sqli.status, sqli.body.slice(0, 80));

  const loginOk = await req('POST', '/api/auth/login', {
    login: 'ra@universidade.edu.br',
    password: '123456',
  });
  const { token } = JSON.parse(loginOk.body);

  console.log('\n=== 4. SQL injection date (com token) ===');
  const badDate = await req(
    'GET',
    "/api/schedule?date=2026-05-22' OR 1=1--",
    null,
    { Authorization: `Bearer ${token}` },
  );
  console.log('schedule bad date ->', badDate.status, badDate.body.slice(0, 100));

  console.log('\n=== 5. Requisicoes em massa (login) ===');
  const flood = await floodLogin(50);
  console.log(JSON.stringify(flood));

  console.log('\n=== 6. IDOR: token de outro studentId? ===');
  const jwt = require('jsonwebtoken');
  require('dotenv').config({ path: require('path').join(__dirname, '..', '.env') });
  const forged = jwt.sign(
    { userId: 1, studentId: 99999 },
    process.env.JWT_SECRET,
    { expiresIn: '1h' },
  );
  const idor = await req('GET', '/api/students/me', null, {
    Authorization: `Bearer ${forged}`,
  });
  console.log('forged studentId=99999 ->', idor.status, idor.body.slice(0, 80));
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
