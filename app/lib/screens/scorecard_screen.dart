import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../providers/app_state_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/clay_button.dart';
import '../widgets/clay_card.dart';
import 'dashboard_screen.dart';
import 'training_screen.dart';

class ScorecardScreen extends StatelessWidget {
  final AppStateProvider appState;
  final ModuleDefinition module;
  final int levelIndex;
  final int score;
  final int total;
  final bool passed;

  const ScorecardScreen({
    super.key,
    required this.appState,
    required this.module,
    required this.levelIndex,
    required this.score,
    required this.total,
    required this.passed,
  });

  @override
  Widget build(BuildContext context) {
    final double percentage = total > 0 ? (score / total) * 100 : 0;
    final int stars = percentage >= 80 ? 3 : (percentage >= 40 ? 2 : 1);

    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Home button in corner
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => DashboardScreen(appState: appState),
                      ),
                      (route) => false,
                    );
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.pastelPeach,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.borderDark, width: 4),
                      boxShadow: const [
                        BoxShadow(
                          color: AppTheme.borderDark,
                          offset: Offset(0, 3),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.home_rounded,
                      color: AppTheme.textMain,
                      size: 28,
                    ),
                  ),
                ),
              ),
              const Spacer(),

              // Title
              Text(
                passed ? 'Level Unlocked!' : 'Challenge Completed!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textMain,
                ),
              ),
              const SizedBox(height: 18),

              // Star Rating
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  final isLit = index < stars;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(
                      Icons.star_rounded,
                      size: 56,
                      color: isLit ? const Color(0xFFFFD700) : Colors.grey.shade300,
                      shadows: const [
                        Shadow(
                          color: AppTheme.borderDark,
                          offset: Offset(2, 2),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 28),

              // Score Card
              ClayCard(
                padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
                child: Column(
                  children: [
                    const Text(
                      'Your Score',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textMain,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$score / $total',
                      style: const TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textMain,
                      ),
                    ),
                    if (!passed) ...[
                      const SizedBox(height: 12),
                      const Text(
                        'Try again to unlock the next level!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.errorRed,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Spacer(),

              // Next / Retry Button
              ClayButton(
                isFullWidth: true,
                height: 58,
                backgroundColor: passed
                    ? AppTheme.pastelGreen
                    : AppTheme.pastelPeach,
                text: passed ? 'NEXT LEVEL' : 'TRY AGAIN',
                fontSize: 20,
                onPressed: () {
                  if (passed) {
                    final nextLevel = levelIndex + 1;
                    if (nextLevel < module.levelTitles.length) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => TrainingScreen(
                            appState: appState,
                            module: module,
                            levelIndex: nextLevel,
                          ),
                        ),
                      );
                    } else {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => DashboardScreen(appState: appState),
                        ),
                        (route) => false,
                      );
                    }
                  } else {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => TrainingScreen(
                          appState: appState,
                          module: module,
                          levelIndex: levelIndex,
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
