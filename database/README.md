# AIISH Database Layer

This directory houses the database schemas, seed datasets, and migration instructions.

## Schema Overview

- **`children`**: Tracks registered children/patients with age groupings.
- **`modules`**: 5 core auditory closure modules (`phoneme`, `syllable`, `word`, `sentence`, `closure`).
- **`levels`**: Progression stages inside each module.
- **`trials`**: Audio prompt metadata, occluded text, and clue assets.
- **`sessions`**: History of sessions completed with overall scores and pass/fail states.
- **`trial_logs`**: Detailed per-word attempts, audio replays, and clue progression.
- **`therapist_configs`**: Real-time configurable parameters (e.g. passing threshold, clue behavior).

## Quick Start with PostgreSQL

1. Create database:
   ```bash
   createdb aiish_db
   ```
2. Apply schema:
   ```bash
   psql -d aiish_db -f schema/schema.sql
   ```
3. Load initial seed data:
   ```bash
   psql -d aiish_db -f seeds/initial_data.sql
   ```
4. Configure in `backend/.env`:
   ```env
   DATABASE_URL=postgresql://<user>:<password>@localhost:5432/aiish_db
   ```
