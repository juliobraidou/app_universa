# Universa App

Portal academico Flutter do projeto Universa.

## Requisitos

- Flutter 3.11+
- API rodando em `universa_api` (veja README da API)

## Configuracao

1. Inicie a API (`npm run dev` em `../universa_api`).

2. Execute o app:

```bash
flutter pub get
flutter run
```

### URL da API

Definida em `lib/src/config/api_config.dart`:

- Web/Desktop: `http://localhost:3000/api`
- Android emulator: `http://10.0.2.2:3000/api`

## Login de teste

| Campo | Valor |
|-------|-------|
| Email | `ra@universidade.edu.br` |
| Senha | `123456` |
