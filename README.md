# AIISH - Auditory Closure Training System

A gamified, multi-tier training platform designed for children with auditory processing needs, complete with therapist configurations, parent analytics, and progressive level unlock mechanisms.

---

## 📁 Project Architecture

```
AIISH/
├── frontend/                     # Next.js App Router Frontend
│   ├── public/                   # Static assets (mascot images, icons)
│   ├── src/
│   │   ├── app/                  # App routes (/child, /therapist, /parent)
│   │   ├── components/           # Reusable UI components (Button, Card, Header)
│   │   ├── context/              # React state management (AppContext)
│   │   └── services/             # API client calls to backend (api.js)
│   ├── jsconfig.json             # Path alias mapping (@/*)
│   └── package.json
│
├── backend/                      # Node.js / Express API Server
│   ├── src/
│   │   ├── controllers/          # Business logic (sessions, config, progress)
│   │   ├── routes/               # API endpoints (/api/sessions, /api/config, /api/progress)
│   │   ├── config/               # Database connection & memory store
│   │   ├── middleware/           # Centralized error handler
│   │   └── index.js              # Server entry point (Port 5000)
│   ├── Dockerfile
│   └── package.json
│
├── database/                     # Relational Database Schemas & Migrations
│   ├── schema/                   # PostgreSQL schema definitions
│   │   └── schema.sql
│   ├── seeds/                    # Initial seed data for modules, levels, and words
│   │   └── initial_data.sql
│   └── README.md
│
├── docker-compose.yml            # Docker orchestration for Postgres, Backend, and Frontend
└── package.json                  # Root monorepo scripts runner
```

---

## 🚀 Quick Start Guide

### Option 1: Run Locally (Recommended for Development)

#### 1. Start the Frontend (Next.js):
```powershell
cd frontend
npm install
npm run dev
```
Open **[http://localhost:3000](http://localhost:3000)** in your browser.

#### 2. Start the Backend (API Server):
Open a second terminal window:
```powershell
cd backend
npm install
npm run dev
```
The API server will run on **[http://localhost:5000](http://localhost:5000)**.
- Health Check: `http://localhost:5000/api/health`
- Configuration API: `http://localhost:5000/api/config`
- Sessions API: `http://localhost:5000/api/sessions`

---

### Option 2: Run via Docker Compose (Full Stack with PostgreSQL)

To start PostgreSQL, the Backend API, and Next.js Frontend all in one command:
```bash
docker compose up --build
```

---

## 🌐 Application Portals

- **Child Training Interface**: `http://localhost:3000/child`
- **Therapist Management Portal**: `http://localhost:3000/therapist`
- **Parent Progress Insights**: `http://localhost:3000/parent`
