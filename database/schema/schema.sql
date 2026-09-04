-- ==========================================================
-- AIISH Auditory Closure Training System Database Schema
-- Compatible with PostgreSQL & modern relational databases
-- ==========================================================

-- Enable UUID extension if supported
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Patients / Children
CREATE TABLE IF NOT EXISTS children (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age_group VARCHAR(20) NOT NULL, -- e.g., '4-6', '7-9', '10-12'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. Training Modules
CREATE TABLE IF NOT EXISTS modules (
    id VARCHAR(50) PRIMARY KEY, -- 'phoneme', 'syllable', 'word', 'sentence', 'closure'
    title VARCHAR(100) NOT NULL,
    description TEXT,
    order_index INT NOT NULL DEFAULT 0,
    color_hex VARCHAR(10) DEFAULT '#FFB347'
);

-- 3. Sub-Levels per Module
CREATE TABLE IF NOT EXISTS levels (
    id VARCHAR(50) PRIMARY KEY,
    module_id VARCHAR(50) REFERENCES modules(id) ON DELETE CASCADE,
    title VARCHAR(100) NOT NULL,
    level_order INT NOT NULL DEFAULT 0
);

-- 4. Words & Practice Trials
CREATE TABLE IF NOT EXISTS trials (
    id VARCHAR(50) PRIMARY KEY,
    level_id VARCHAR(50) REFERENCES levels(id) ON DELETE CASCADE,
    word VARCHAR(100) NOT NULL,
    occluded_word VARCHAR(100) NOT NULL,
    audio_path VARCHAR(255),
    clue_audio_path VARCHAR(255),
    visual_clue_path VARCHAR(255),
    is_practice BOOLEAN DEFAULT FALSE
);

-- 5. Training Sessions
CREATE TABLE IF NOT EXISTS sessions (
    id VARCHAR(50) PRIMARY KEY,
    child_id VARCHAR(50) REFERENCES children(id) ON DELETE SET NULL,
    module_id VARCHAR(50) REFERENCES modules(id) ON DELETE CASCADE,
    level_id VARCHAR(50) NOT NULL,
    score INT NOT NULL DEFAULT 0,
    total INT NOT NULL DEFAULT 0,
    percentage INT NOT NULL DEFAULT 0,
    passed BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 6. Granular Trial Logs (For Therapist Analysis)
CREATE TABLE IF NOT EXISTS trial_logs (
    id SERIAL PRIMARY KEY,
    session_id VARCHAR(50) REFERENCES sessions(id) ON DELETE CASCADE,
    word_id VARCHAR(50),
    word VARCHAR(100),
    is_correct BOOLEAN NOT NULL,
    play_count INT NOT NULL DEFAULT 1,
    clue_stage_reached INT NOT NULL DEFAULT 0, -- 0: None, 1: Audio Clue, 2: Visual Clue
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 7. Therapist Global Configuration
CREATE TABLE IF NOT EXISTS therapist_configs (
    id INT PRIMARY KEY DEFAULT 1,
    pass_threshold INT NOT NULL DEFAULT 80,
    clue_audio_enabled BOOLEAN NOT NULL DEFAULT TRUE,
    visual_clue_enabled BOOLEAN NOT NULL DEFAULT TRUE,
    max_audio_replays INT NOT NULL DEFAULT 3,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
