# Universa API

API REST do portal academico Universa (Node.js + Express + MySQL).

## Requisitos

- Node.js 18+
- MySQL 8+ (MySQL Workbench)

## Configuracao

1. Copie o arquivo de ambiente:

```bash
cp .env.example .env
```

2. Ajuste `DB_USER`, `DB_PASSWORD` e `JWT_SECRET` no `.env`.

3. No **MySQL Workbench**, crie uma conexao local e execute o script:

   - Arquivo: `database/schema.sql`

   Ou via terminal:

```bash
npm install
npm run db:schema
```

4. Popule os dados de teste:

```bash
npm run db:seed
```

5. Inicie a API:

```bash
npm run dev
```

A API ficara em `http://localhost:3000`.

## Credenciais de teste

| Campo | Valor |
|-------|-------|
| Email | `ra@universidade.edu.br` |
| RA | `20260000` |
| Senha | `123456` |

## Endpoints

| Metodo | Rota | Auth |
|--------|------|------|
| GET | `/health` | Nao |
| POST | `/api/auth/login` | Nao |
| GET | `/api/students/me` | JWT |
| GET | `/api/students/me/summary` | JWT |
| GET | `/api/schedule/today` | JWT |
| GET | `/api/schedule?date=YYYY-MM-DD` | JWT |
| GET | `/api/grades` | JWT |
| GET | `/api/attendance` | JWT |

### Login

```http
POST /api/auth/login
Content-Type: application/json

{
  "login": "ra@universidade.edu.br",
  "password": "123456"
}
```

### Rotas protegidas

Envie o header:

```
Authorization: Bearer <token>
```

## Estrutura do banco

- `users` — login (email, RA, senha bcrypt)
- `students` — dados do aluno e carteirinha
- `subjects` — disciplinas
- `enrollments` — matriculas
- `grades` — notas P1/P2/P3
- `attendance` — frequencia
- `schedule_events` — agenda por data

## Scripts

| Comando | Descricao |
|---------|-----------|
| `npm run dev` | Servidor com hot reload |
| `npm start` | Servidor em producao |
| `npm run db:schema` | Cria tabelas |
| `npm run db:seed` | Insere dados de demonstracao |

## Seguranca

- **Rate limit:** login (10 tentativas / 15 min) e API geral (120 req / min)
- **CORS:** configure `CORS_ORIGINS` no `.env` (origens separadas por virgula)
- **JWT:** middleware valida se `studentId` pertence ao `userId` do token
- **Helmet:** headers HTTP de protecao basica

Teste rapido: `node scripts/security-smoke-test.js`
