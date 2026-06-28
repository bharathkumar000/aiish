import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../providers/app_state_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import 'training_screen.dart';

class LevelSelectScreen extends StatelessWidget {
  final AppStateProvider appState;
  final ModuleDefinition module;

  const LevelSelectScreen({
    super.key,
    required this.appState,
    required this.module,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppTheme.bgPrimary,
          body: Column(
            children: [
              AppHeader(
                title: 'Select Level',
                showBack: true,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 4),
                child: Text(
                  module.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textMuted,
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  itemCount: module.levelTitles.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 18),
                  itemBuilder: (context, index) {
                    final levelTitle = module.levelTitles[index];
                    final isUnlocked = appState.isLevelUnlocked(module.id, index);

                    return _LevelCard(
                      title: levelTitle,
                      levelIndex: index,
                      isUnlocked: isUnlocked,
                      onTap: isUnlocked
                          ? () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => TrainingScreen(
                                    appState: appState,
                                    module: module,
                                    levelIndex: index,
                                  ),
                                ),
                              );
                            }
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LevelCard extends StatefulWidget {
  final String title;
  final int levelIndex;
  final bool isUnlocked;
  final VoidCallback? onTap;

  const _LevelCard({
    required this.title,
    required this.levelIndex,
    required this.isUnlocked,
    this.onTap,
  });

  @override
  State<_LevelCard> createState() => _LevelCardState();
}

class _LevelCardState extends State<_LevelCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final double offsetY = (_isPressed && widget.isUnlocked) ? 1 : 6;
    final double translateY = (_isPressed && widget.isUnlocked) ? 5 : 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 70),
      transform: Matrix4.translationValues(0, translateY, 0),
      child: GestureDetector(
        onTapDown: widget.isUnlocked ? (_) => setState(() => _isPressed = true) : null,
        onTapUp: widget.isUnlocked
            ? (_) {
                setState(() => _isPressed = false);
                widget.onTap?.call();
              }
            : null,
        onTapCancel: widget.isUnlocked ? () => setState(() => _isPressed = false) : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.borderDark.withValues(alpha: widget.isUnlocked ? 1.0 : 0.4),
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.borderDark.withValues(alpha: widget.isUnlocked ? 1.0 : 0.3),
                offset: Offset(0, offsetY),
                blurRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Level ${widget.levelIndex + 1}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: widget.isUnlocked ? AppTheme.textMuted : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: widget.isUnlocked
                            ? AppTheme.textMain
                            : AppTheme.textMain.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: widget.isUnlocked
                      ? AppTheme.pastelPeach
                      : Colors.grey.shade200,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.borderDark.withValues(alpha: widget.isUnlocked ? 1.0 : 0.3),
                    width: 3,
                  ),
                ),
                child: Icon(
                  widget.isUnlocked ? Icons.play_arrow_rounded : Icons.lock_rounded,
                  color: widget.isUnlocked ? AppTheme.textMain : Colors.grey,
                  size: 26,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
