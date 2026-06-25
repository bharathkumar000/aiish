import 'package:flutter/material.dart';

class TrainingTrial {
  final String id;
  final String word;
  final String occludedWord;
  final bool isPractice;
  final String? cluePrompt;
  final IconData? visualIcon;

  const TrainingTrial({
    required this.id,
    required this.word,
    required this.occludedWord,
    this.isPractice = false,
    this.cluePrompt,
    this.visualIcon,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'word': word,
    'occludedWord': occludedWord,
    'isPractice': isPractice,
    'cluePrompt': cluePrompt,
  };
}

class TrialResult {
  final String wordId;
  final String word;
  final bool isCorrect;
  final int playCount;
  final int clueStageReached;

  TrialResult({
    required this.wordId,
    required this.word,
    required this.isCorrect,
    required this.playCount,
    required this.clueStageReached,
  });

  Map<String, dynamic> toJson() => {
    'wordId': wordId,
    'word': word,
    'isCorrect': isCorrect,
    'playCount': playCount,
    'clueStageReached': clueStageReached,
  };

  factory TrialResult.fromJson(Map<String, dynamic> json) => TrialResult(
    wordId: json['wordId'] as String? ?? '',
    word: json['word'] as String? ?? '',
    isCorrect: json['isCorrect'] as bool? ?? false,
    playCount: json['playCount'] as int? ?? 1,
    clueStageReached: json['clueStageReached'] as int? ?? 0,
  );
}

class SessionLog {
  final String moduleId;
  final String levelId;
  final int score;
  final int total;
  final bool passed;
  final DateTime timestamp;
  final List<TrialResult> trials;

  SessionLog({
    required this.moduleId,
    required this.levelId,
    required this.score,
    required this.total,
    required this.passed,
    required this.timestamp,
    required this.trials,
  });

  Map<String, dynamic> toJson() => {
    'moduleId': moduleId,
    'levelId': levelId,
    'score': score,
    'total': total,
    'passed': passed,
    'timestamp': timestamp.toIso8601String(),
    'trials': trials.map((t) => t.toJson()).toList(),
  };

  factory SessionLog.fromJson(Map<String, dynamic> json) => SessionLog(
    moduleId: json['moduleId'] as String? ?? '',
    levelId: json['levelId'] as String? ?? '0',
    score: json['score'] as int? ?? 0,
    total: json['total'] as int? ?? 0,
    passed: json['passed'] as bool? ?? false,
    timestamp: json['timestamp'] != null
        ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
        : DateTime.now(),
    trials: (json['trials'] as List<dynamic>?)
            ?.map((t) => TrialResult.fromJson(t as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

class TherapistConfig {
  int passThreshold;
  bool clueAudioEnabled;
  bool visualClueEnabled;
  int maxAudioReplays;

  TherapistConfig({
    this.passThreshold = 80,
    this.clueAudioEnabled = true,
    this.visualClueEnabled = true,
    this.maxAudioReplays = 3,
  });

  Map<String, dynamic> toJson() => {
    'passThreshold': passThreshold,
    'clueAudioEnabled': clueAudioEnabled,
    'visualClueEnabled': visualClueEnabled,
    'maxAudioReplays': maxAudioReplays,
  };

  factory TherapistConfig.fromJson(Map<String, dynamic> json) => TherapistConfig(
    passThreshold: json['passThreshold'] as int? ?? 80,
    clueAudioEnabled: json['clueAudioEnabled'] as bool? ?? true,
    visualClueEnabled: json['visualClueEnabled'] as bool? ?? true,
    maxAudioReplays: json['maxAudioReplays'] as int? ?? 3,
  );
}

class ModuleDefinition {
  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final List<String> levelTitles;

  const ModuleDefinition({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    required this.levelTitles,
  });
}

class TrainingDataRepository {
  static const List<ModuleDefinition> modules = [
    ModuleDefinition(
      id: 'phoneme',
      title: 'Missing Phoneme',
      icon: Icons.mic_rounded,
      color: Color(0xFFFCD5CE),
      levelTitles: [
        'Initial Omission',
        'Medial Omission',
        'Final Omission',
        'Phoneme Blending',
        'Speech in Noise',
      ],
    ),
    ModuleDefinition(
      id: 'syllable',
      title: 'Missing Syllable',
      icon: Icons.menu_book_rounded,
      color: Color(0xFFD8E2DC),
      levelTitles: [
        'Initial Syllable',
        'Medial Syllable',
        'Final Syllable',
      ],
    ),
    ModuleDefinition(
      id: 'word',
      title: 'Missing Word',
      icon: Icons.chat_bubble_rounded,
      color: Color(0xFFBDE0FE),
      levelTitles: [
        'Level 1 (Objects)',
        'Level 2 (Actions)',
        'Level 3 (Animals)',
      ],
    ),
    ModuleDefinition(
      id: 'sentence',
      title: 'Sentence Completion',
      icon: Icons.extension_rounded,
      color: Color(0xFFFFC8DD),
      levelTitles: [
        'Everyday Sentences',
        'School Stories',
        'Riddles & Rhymes',
      ],
    ),
    ModuleDefinition(
      id: 'closure',
      title: 'Auditory Closure',
      icon: Icons.headphones_rounded,
      color: Color(0xFFFFF1E6),
      levelTitles: [
        'Mild Filter',
        'Moderate Filter',
        'Background Noise',
      ],
    ),
  ];

  static List<TrainingTrial> getTrialsForLevel(String moduleId, int levelIndex) {
    // Customized dataset per module for great variety
    switch (moduleId) {
      case 'phoneme':
        return [
          const TrainingTrial(
            id: 'p_prac',
            word: 'MILK',
            occludedWord: 'Mil__',
            isPractice: true,
            cluePrompt: 'A healthy white drink from cows!',
            visualIcon: Icons.local_drink_rounded,
          ),
          const TrainingTrial(
            id: 'p_1',
            word: 'APPLE',
            occludedWord: 'A__LE',
            isPractice: false,
            cluePrompt: 'A crunchy sweet red fruit!',
            visualIcon: Icons.apple_rounded,
          ),
          const TrainingTrial(
            id: 'p_2',
            word: 'CAT',
            occludedWord: 'C_T',
            isPractice: false,
            cluePrompt: 'Says meow and loves to purr!',
            visualIcon: Icons.pets_rounded,
          ),
          const TrainingTrial(
            id: 'p_3',
            word: 'DOG',
            occludedWord: 'D_G',
            isPractice: false,
            cluePrompt: 'Barks and wags its happy tail!',
            visualIcon: Icons.cruelty_free_rounded,
          ),
        ];
      case 'syllable':
        return [
          const TrainingTrial(
            id: 's_prac',
            word: 'BUTTERFLY',
            occludedWord: 'But-ter-__',
            isPractice: true,
            cluePrompt: 'Colorful wings that flutter in gardens!',
            visualIcon: Icons.flutter_dash_rounded,
          ),
          const TrainingTrial(
            id: 's_1',
            word: 'BANANA',
            occludedWord: 'Ba-na-__',
            isPractice: false,
            cluePrompt: 'Yellow fruit loved by monkeys!',
            visualIcon: Icons.eco_rounded,
          ),
          const TrainingTrial(
            id: 's_2',
            word: 'ELEPHANT',
            occludedWord: 'El-e-____',
            isPractice: false,
            cluePrompt: 'Largest land animal with big ears!',
            visualIcon: Icons.landscape_rounded,
          ),
          const TrainingTrial(
            id: 's_3',
            word: 'AIRPLANE',
            occludedWord: 'Air-_____',
            isPractice: false,
            cluePrompt: 'Flies high up across the clouds!',
            visualIcon: Icons.flight_takeoff_rounded,
          ),
        ];
      case 'word':
        return [
          const TrainingTrial(
            id: 'w_prac',
            word: 'SUNSHINE',
            occludedWord: 'Sun-____',
            isPractice: true,
            cluePrompt: 'Warm bright light from the sky!',
            visualIcon: Icons.wb_sunny_rounded,
          ),
          const TrainingTrial(
            id: 'w_1',
            word: 'RAINBOW',
            occludedWord: 'Rain-____',
            isPractice: false,
            cluePrompt: 'Seven beautiful colors after rain!',
            visualIcon: Icons.looks_rounded,
          ),
          const TrainingTrial(
            id: 'w_2',
            word: 'BICYCLE',
            occludedWord: 'Bi-_____',
            isPractice: false,
            cluePrompt: 'Two wheels that you pedal along!',
            visualIcon: Icons.pedal_bike_rounded,
          ),
          const TrainingTrial(
            id: 'w_3',
            word: 'STARFISH',
            occludedWord: 'Star-____',
            isPractice: false,
            cluePrompt: 'Five-armed creature in the ocean tide!',
            visualIcon: Icons.star_rounded,
          ),
        ];
      case 'sentence':
        return [
          const TrainingTrial(
            id: 'st_prac',
            word: 'SKY IS BLUE',
            occludedWord: 'The sky is ____',
            isPractice: true,
            cluePrompt: 'Like the ocean color on sunny days!',
            visualIcon: Icons.cloud_rounded,
          ),
          const TrainingTrial(
            id: 'st_1',
            word: 'GRASS IS GREEN',
            occludedWord: 'The grass is _____',
            isPractice: false,
            cluePrompt: 'The color of leaves and emeralds!',
            visualIcon: Icons.park_rounded,
          ),
          const TrainingTrial(
            id: 'st_2',
            word: 'BIRDS CAN FLY',
            occludedWord: 'Birds can ____',
            isPractice: false,
            cluePrompt: 'Soaring high above the ground!',
            visualIcon: Icons.air_rounded,
          ),
          const TrainingTrial(
            id: 'st_3',
            word: 'FISH CAN SWIM',
            occludedWord: 'Fish can _____',
            isPractice: false,
            cluePrompt: 'Gliding smoothly under blue water!',
            visualIcon: Icons.waves_rounded,
          ),
        ];
      case 'closure':
      default:
        return [
          const TrainingTrial(
            id: 'c_prac',
            word: 'UMBRELLA',
            occludedWord: 'Um-bre-__',
            isPractice: true,
            cluePrompt: 'Keeps you dry when drops start pouring!',
            visualIcon: Icons.umbrella_rounded,
          ),
          const TrainingTrial(
            id: 'c_1',
            word: 'PENCIL',
            occludedWord: 'Pen-___',
            isPractice: false,
            cluePrompt: 'Used with an eraser to write your thoughts!',
            visualIcon: Icons.edit_rounded,
          ),
          const TrainingTrial(
            id: 'c_2',
            word: 'GUITAR',
            occludedWord: 'Gui-___',
            isPractice: false,
            cluePrompt: 'Six strings making lovely musical sounds!',
            visualIcon: Icons.music_note_rounded,
          ),
          const TrainingTrial(
            id: 'c_3',
            word: 'TIGER',
            occludedWord: 'Ti-___',
            isPractice: false,
            cluePrompt: 'Striped king of the jungle with stripes!',
            visualIcon: Icons.flash_on_rounded,
          ),
        ];
    }
  }
}
