-- ==========================================================
-- AIISH Auditory Closure Initial Seeds
-- ==========================================================

-- Insert Default Modules
INSERT INTO modules (id, title, description, order_index, color_hex) VALUES
('phoneme', 'Missing Phoneme', 'Identify words with missing sound phonemes', 1, '#FCD5CE'),
('syllable', 'Missing Syllable', 'Identify words with missing syllables', 2, '#D8E2DC'),
('word', 'Missing Word', 'Fill in missing words in speech context', 3, '#BDE0FE'),
('sentence', 'Sentence Completion', 'Complete missing sentence closures', 4, '#FFC8DD'),
('closure', 'Auditory Closure', 'Full auditory closure under varying noise levels', 5, '#FFF1E6')
ON CONFLICT (id) DO NOTHING;

-- Insert Sub-Levels for Phoneme Module
INSERT INTO levels (id, module_id, title, level_order) VALUES
('phoneme_0', 'phoneme', 'Initial Omission', 0),
('phoneme_1', 'phoneme', 'Medial Omission', 1),
('phoneme_2', 'phoneme', 'Final Omission', 2),
('phoneme_3', 'phoneme', 'Phoneme Blending', 3),
('phoneme_4', 'phoneme', 'Speech in Noise', 4)
ON CONFLICT (id) DO NOTHING;

-- Insert Default Therapist Config
INSERT INTO therapist_configs (id, pass_threshold, clue_audio_enabled, visual_clue_enabled, max_audio_replays)
VALUES (1, 80, TRUE, TRUE, 3)
ON CONFLICT (id) DO UPDATE SET
    pass_threshold = EXCLUDED.pass_threshold,
    clue_audio_enabled = EXCLUDED.clue_audio_enabled,
    visual_clue_enabled = EXCLUDED.visual_clue_enabled,
    max_audio_replays = EXCLUDED.max_audio_replays;

-- Insert Sample Practice and Trial Words
INSERT INTO trials (id, level_id, word, occluded_word, is_practice) VALUES
('trial_prac_1', 'phoneme_0', 'MILK', 'Mil__', TRUE),
('trial_1', 'phoneme_0', 'APPLE', 'A__LE', FALSE),
('trial_2', 'phoneme_0', 'CAT', 'C_T', FALSE),
('trial_3', 'phoneme_0', 'DOG', 'D_G', FALSE)
ON CONFLICT (id) DO NOTHING;
