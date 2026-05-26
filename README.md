<p align="center">
  <h1 align="center">Universa</h1>
  <p align="center">
    Portal acadêmico full stack — API REST + app Flutter
  </p>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Node.js-18+-339933?logo=node.js&logoColor=white" alt="Node.js" />
  <img src="https://img.shields.io/badge/Flutter-3.11+-02569B?logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/MySQL-8+-4479A1?logo=mysql&logoColor=white" alt="MySQL" />
  <img src="https://img.shields.io/badge/JWT-Auth-000000?logo=jsonwebtokens&logoColor=white" alt="JWT" />
</p>

---

## Sobre o projeto

**Universa** é um portal acadêmico para alunos consultarem informações da graduação: resumo com IRA, notas, frequência, agenda de aulas e carteirinha digital.

O repositório é um monorepo com backend e frontend integrados por API REST autenticada com JWT.

## Preview

<!-- Substitua pelo print real depois de subir no GitHub -->
<!-- <img src="docs/screenshots/login.png" width="280" /> <img src="docs/screenshots/dash.png" width="280" /> -->

> Adicione prints em `docs/screenshots/` e descomente as linhas acima para exibir no README.

## Funcionalidades

- Login com **e-mail** ou **RA** e senha
- Dashboard com resumo acadêmico e IRA
- Boletim de notas (P1, P2, P3 e média final)
- Frequência por disciplina
- Agenda do dia e consulta por data
- Carteirinha digital do aluno
- Logout com confirmação e token em armazenamento seguro

## Stack

| | Tecnologias |
|---|-------------|
| **API** | Node.js, Express, MySQL, JWT, bcrypt, Zod, Helmet, express-rate-limit |
| **App** | Flutter, Provider, Dio, flutter_secure_storage, Google Fonts |

## Estrutura

```
.
├── universa_api/          # Backend REST
│   ├── database/          # schema.sql e seed.sql
│   ├── src/
│   └── scripts/
└── universa_app/          # App Flutter
    └── lib/src/
        ├── pages/
        ├── repositories/
        └── widgets/
```

## Pré-requisitos

- [Node.js](https://nodejs.org/) 18+
- [MySQL](https://www.mysql.com/) 8+
- [Flutter](https://flutter.dev/) 3.11+

## Instalação e execução

### 1. Clone o repositório

```bash
git clone https://github.com/SEU_USUARIO/provaNivaldo.git
cd provaNivaldo
```

> Troque `SEU_USUARIO/provaNivaldo` pela URL real do seu repositório.

### 2. Suba a API

```bash
cd universa_api
cp .env.example .env
```

Configure no `.env`: `DB_USER`, `DB_PASSWORD`, `JWT_SECRET` e, se precisar, `CORS_ORIGINS`.

```bash
npm install
npm run db:schema
npm run db:seed
npm run dev
```

API disponível em: **http://localhost:3000**

### 3. Suba o app

```bash
cd ../universa_app
flutter pub get
flutter run
```

| Plataforma | URL da API |
|------------|------------|
| Web / Desktop | `http://localhost:3000/api` |
| Emulador Android | `http://10.0.2.2:3000/api` |

Configuração em [`universa_app/lib/src/config/api_config.dart`](universa_app/lib/src/config/api_config.dart).

## Login de demonstração

Use após rodar o seed (`npm run db:seed`):

```
E-mail: ra@universidade.edu.br
RA:     20260000
Senha:  123456
```

## API

### Health check

```http
GET /health
```

### Login

```http
POST /api/auth/login
Content-Type: application/json

{
  "login": "ra@universidade.edu.br",
  "password": "123456"
}
```

### Rotas autenticadas

Envie o token no header:

```http
Authorization: Bearer <seu_token>
```

| Método | Rota |
|--------|------|
| `GET` | `/api/students/me` |
| `GET` | `/api/students/me/summary` |
| `GET` | `/api/schedule/today` |
| `GET` | `/api/schedule?date=YYYY-MM-DD` |
| `GET` | `/api/grades` |
| `GET` | `/api/attendance` |

Detalhes completos: [`universa_api/README.md`](universa_api/README.md)

## Testes

```bash
# API — smoke test de segurança
cd universa_api
node scripts/security-smoke-test.js

# App
cd ../universa_app
flutter test
flutter analyze
```

## Variáveis de ambiente

Arquivo de exemplo: [`universa_api/.env.example`](universa_api/.env.example)

| Variável | Descrição |
|----------|-----------|
| `PORT` | Porta do servidor |
| `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASSWORD`, `DB_NAME` | MySQL |
| `JWT_SECRET` | Chave de assinatura do token |
| `JWT_EXPIRES_IN` | Expiração do token (ex.: `7d`) |
| `CORS_ORIGINS` | Origens permitidas (vírgula) |

> **Não commite o `.env`** — só o `.env.example`.

## Segurança

- Rate limit no login e na API geral
- CORS configurável por ambiente
- Senhas com bcrypt
- JWT validando vínculo usuário ↔ aluno
- Headers HTTP com Helmet

## Documentação extra

- [API — setup, endpoints e banco](universa_api/README.md)
- [App — execução e plataformas](universa_app/README.md)

## Autor

@juliobraidou

## Licença

Projeto acadêmico. Uso conforme orientações da instituição/disciplina.
