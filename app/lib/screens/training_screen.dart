import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../providers/app_state_provider.dart';
import '../services/audio_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/clay_button.dart';
import '../widgets/clay_card.dart';
import 'scorecard_screen.dart';
import 'victory_screen.dart';

class TrainingScreen extends StatefulWidget {
  final AppStateProvider appState;
  final ModuleDefinition module;
  final int levelIndex;

  const TrainingScreen({
    super.key,
    required this.appState,
    required this.module,
    required this.levelIndex,
  });

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen>
    with SingleTickerProviderStateMixin {
  late final List<TrainingTrial> _trials;
  int _currentTrialIndex = 0;

  int _playCount = 0;
  int _clueStage = 0; // 0: None, 1: Audio Clue, 2: Visual Clue
  bool _showFeedback = false;
  String? _feedbackState; // 'success', 'fail_final'

  int _score = 0;
  final List<TrialResult> _trialLogs = [];

  late final AnimationController _animController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _trials = TrainingDataRepository.getTrialsForLevel(
      widget.module.id,
      widget.levelIndex,
    );

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    // Speak introductory trial word after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playAudio('training');
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    AudioService().stop();
    super.dispose();
  }

  TrainingTrial get currentTrial => _trials[_currentTrialIndex];

  void _playAudio(String type) {
    if (_playCount >= widget.appState.therapistConfig.maxAudioReplays &&
        type == 'training' &&
        _clueStage == 0) {
      return;
    }

    if (type == 'clue') {
      AudioService().speakClue(currentTrial.cluePrompt ?? currentTrial.word);
    } else {
      AudioService().speakTrainingWord(currentTrial.word);
      setState(() {
        _playCount++;
      });
    }

    _animController.forward(from: 0).then((_) => _animController.reverse());
  }

  void _handleOperatorAnswer(bool isCorrect) {
    if (isCorrect) {
      if (!currentTrial.isPractice) {
        _score++;
      }
      _logTrial(true);
      setState(() {
        _feedbackState = 'success';
        _showFeedback = true;
      });
    } else {
      if (_clueStage == 0) {
        setState(() {
          _clueStage = 1;
        });
        _playAudio('clue');
      } else if (_clueStage == 1) {
        setState(() {
          _clueStage = 2;
        });
      } else {
        _logTrial(false);
        setState(() {
          _feedbackState = 'fail_final';
          _showFeedback = true;
        });
      }
    }
  }

  void _logTrial(bool isCorrect) {
    if (currentTrial.isPractice) return;
    _trialLogs.add(
      TrialResult(
        wordId: currentTrial.id,
        word: currentTrial.word,
        isCorrect: isCorrect,
        playCount: _playCount,
        clueStageReached: _clueStage,
      ),
    );
  }

  void _handleNext() async {
    if (_currentTrialIndex < _trials.length - 1) {
      setState(() {
        _currentTrialIndex++;
        _playCount = 0;
        _clueStage = 0;
        _showFeedback = false;
        _feedbackState = null;
      });
      _playAudio('training');
    } else {
      // Completed session
      final scoredTrials = _trials.where((t) => !t.isPractice).length;
      final percentage = scoredTrials > 0 ? (_score / scoredTrials) * 100 : 100.0;
      final passed = percentage >= widget.appState.therapistConfig.passThreshold;

      final sessionLog = SessionLog(
        moduleId: widget.module.id,
        levelId: widget.levelIndex.toString(),
        score: _score,
        total: scoredTrials,
        passed: passed,
        timestamp: DateTime.now(),
        trials: _trialLogs,
      );

      await widget.appState.addSessionLog(sessionLog);

      bool gameBeaten = false;
      if (passed) {
        final nextLevelIndex = widget.levelIndex + 1;
        if (nextLevelIndex < widget.module.levelTitles.length) {
          // Unlock next level in current module
          await widget.appState.unlockLevel(widget.module.id, nextLevelIndex);
        } else {
          // Module completed! Unlock next module
          final allModules = TrainingDataRepository.modules;
          final curIdx = allModules.indexWhere((m) => m.id == widget.module.id);
          if (curIdx != -1 && curIdx < allModules.length - 1) {
            final nextMod = allModules[curIdx + 1];
            await widget.appState.unlockModule(nextMod.id);
            await widget.appState.unlockLevel(nextMod.id, 0);
          } else if (curIdx == allModules.length - 1) {
            gameBeaten = true;
          }
        }
      }

      if (!mounted) return;

      if (gameBeaten) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => VictoryScreen(appState: widget.appState),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ScorecardScreen(
              appState: widget.appState,
              module: widget.module,
              levelIndex: widget.levelIndex,
              score: _score,
              total: scoredTrials,
              passed: passed,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scoredTotal = _trials.where((t) => !t.isPractice).length;
    final trialTitle = currentTrial.isPractice
        ? 'Practice Round!'
        : 'Trial $_currentTrialIndex of $scoredTotal';

    final maxReplays = widget.appState.therapistConfig.maxAudioReplays;
    final canPlayAudio = (_playCount < maxReplays) || (_clueStage > 0);

    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      body: Column(
        children: [
          AppHeader(
            title: trialTitle,
            showBack: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Mascot with Speech Bubble
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppTheme.borderDark, width: 4),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/mascot.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => const Icon(
                                Icons.pets_rounded,
                                size: 60,
                                color: AppTheme.textMain,
                              ),
                            ),
                          ),
                        ),
                        if (!_showFeedback && _clueStage == 0)
                          Positioned(
                            top: -10,
                            right: -30,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppTheme.borderDark,
                                  width: 3,
                                ),
                              ),
                              child: const Text(
                                'Listen!',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.textMain,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        if (!_showFeedback && _clueStage == 1)
                          Positioned(
                            top: -12,
                            right: -50,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.pastelYellow,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppTheme.borderDark,
                                  width: 3,
                                ),
                              ),
                              child: const Text(
                                "Here's a clue!",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.textMain,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Big Circular Audio Button
                  GestureDetector(
                    onTap: canPlayAudio
                        ? () => _playAudio(_clueStage > 0 ? 'clue' : 'training')
                        : null,
                    child: Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        color: canPlayAudio
                            ? AppTheme.secondary
                            : Colors.grey.shade400,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.borderDark, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.borderDark,
                            offset: const Offset(0, 5),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.volume_up_rounded,
                        size: 44,
                        color: AppTheme.textMain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    'Plays: $_playCount / $maxReplays',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textMuted,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Visual Clue Box (Stage 2)
                  if (_clueStage == 2 && !_showFeedback) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.pastelBlue,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.borderDark, width: 3),
                        boxShadow: const [
                          BoxShadow(
                            color: AppTheme.borderDark,
                            offset: Offset(0, 3),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            currentTrial.visualIcon ?? Icons.lightbulb_rounded,
                            color: AppTheme.textMain,
                            size: 26,
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              currentTrial.cluePrompt ?? 'Visual Clue Hint',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textMain,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Word Display Card
                  ClayCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 30,
                    ),
                    child: Center(
                      child: Text(
                        _showFeedback
                            ? currentTrial.word
                            : currentTrial.occludedWord,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 34,
                          letterSpacing: 4,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.textMain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Facilitator / Feedback Section
                  if (!_showFeedback) ...[
                    const Text(
                      '• FACILITATOR ONLY •',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.errorRed,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ClayButton(
                            height: 56,
                            backgroundColor: const Color(0xFFFF9999),
                            text: 'INCORRECT',
                            fontSize: 16,
                            onPressed: () => _handleOperatorAnswer(false),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: ClayButton(
                            height: 56,
                            backgroundColor: const Color(0xFFA3D9A5),
                            text: 'CORRECT',
                            fontSize: 16,
                            onPressed: () => _handleOperatorAnswer(true),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    // Feedback State
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _feedbackState == 'success'
                              ? Icons.check_circle_rounded
                              : Icons.error_rounded,
                          size: 34,
                          color: _feedbackState == 'success'
                              ? const Color(0xFF2E7D32)
                              : AppTheme.errorRed,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _feedbackState == 'success'
                              ? 'Awesome job!'
                              : 'Better luck next time!',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: _feedbackState == 'success'
                                ? const Color(0xFF2E7D32)
                                : AppTheme.errorRed,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    ClayButton(
                      isFullWidth: true,
                      height: 56,
                      backgroundColor: AppTheme.pastelPeach,
                      text: _currentTrialIndex < _trials.length - 1
                          ? 'NEXT WORD'
                          : 'SEE RESULTS!',
                      fontSize: 18,
                      onPressed: _handleNext,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
