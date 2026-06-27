import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../providers/app_state_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import 'level_select_screen.dart';
import 'parent_portal_screen.dart';
import 'therapist_portal_screen.dart';

class DashboardScreen extends StatelessWidget {
  final AppStateProvider appState;

  const DashboardScreen({super.key, required this.appState});

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
                title: 'Choose a Game!',
                showBack: false,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.family_restroom_rounded, color: AppTheme.textMain),
                      tooltip: 'Parent Portal',
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ParentPortalScreen(appState: appState),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings_rounded, color: AppTheme.textMain),
                      tooltip: 'Therapist Portal',
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => TherapistPortalScreen(appState: appState),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  itemCount: TrainingDataRepository.modules.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 18),
                  itemBuilder: (context, index) {
                    final mod = TrainingDataRepository.modules[index];
                    final isUnlocked = appState.isModuleUnlocked(mod.id);

                    return _ModuleCard(
                      module: mod,
                      isUnlocked: isUnlocked,
                      onTap: isUnlocked
                          ? () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => LevelSelectScreen(
                                    appState: appState,
                                    module: mod,
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

class _ModuleCard extends StatefulWidget {
  final ModuleDefinition module;
  final bool isUnlocked;
  final VoidCallback? onTap;

  const _ModuleCard({
    required this.module,
    required this.isUnlocked,
    this.onTap,
  });

  @override
  State<_ModuleCard> createState() => _ModuleCardState();
}

class _ModuleCardState extends State<_ModuleCard> {
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
            color: widget.isUnlocked
                ? widget.module.color
                : widget.module.color.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.borderDark.withValues(alpha: widget.isUnlocked ? 1.0 : 0.4),
              width: 5,
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
            children: [
              // Icon Circle
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.borderDark.withValues(alpha: widget.isUnlocked ? 1.0 : 0.4),
                    width: 4,
                  ),
                ),
                child: Icon(
                  widget.module.icon,
                  size: 32,
                  color: widget.isUnlocked
                      ? AppTheme.textMain
                      : AppTheme.textMain.withValues(alpha: 0.4),
                ),
              ),
              const SizedBox(width: 18),

              // Title
              Expanded(
                child: Text(
                  widget.module.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: widget.isUnlocked
                        ? AppTheme.textMain
                        : AppTheme.textMain.withValues(alpha: 0.4),
                  ),
                ),
              ),

              // Lock / Arrow Icon
              if (!widget.isUnlocked)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.borderDark.withValues(alpha: 0.4), width: 2),
                  ),
                  child: const Icon(Icons.lock_rounded, size: 20, color: AppTheme.textMuted),
                )
              else
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.borderDark, width: 2),
                  ),
                  child: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppTheme.textMain),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
