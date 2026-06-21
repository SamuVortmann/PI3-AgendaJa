# Agenda Já

Sistema de agendamento para pequenos negócios.

## Estrutura

- `agenda-api/` — Backend Node.js + Express + PostgreSQL
- `agenda-ja/` — App Flutter (cliente e admin)

## Pré-requisitos

- Node.js 20+
- PostgreSQL 16+
- Flutter 3.11+

## Backend

```bash
# Na raiz do repositório, copie o .env
cp .env.example .env
# Edite DB_PASSWORD e JWT_SECRET

cd agenda-api
npm install
npm run db:schema
npm run db:seed
npm run dev
```

API em `http://localhost:3000`

**Admin padrão:** `admin@agendaja.com` / `admin123`

## Flutter

```bash
cd agenda-ja
flutter pub get
flutter run
```

### URL da API

- Windows/macOS/iOS simulador: `http://localhost:3000`
- Emulador Android: `http://10.0.2.2:3000`

Configurável em `agenda-ja/lib/config/api_config.dart`

## Fluxos

**Cliente:** cadastro → login → escolher serviço → profissional → data/horário → confirmar

**Admin:** login → dashboard → agenda → gestão de serviços/profissionais

## WhatsApp (opcional)

No `.env`, defina `WHATSAPP_ENABLED=true` e escaneie o QR Code no terminal ao iniciar a API.
