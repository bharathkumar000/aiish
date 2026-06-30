import 'package:flutter/material.dart';
import '../providers/app_state_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/clay_card.dart';

class ParentPortalScreen extends StatelessWidget {
  final AppStateProvider appState;

  const ParentPortalScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final logs = appState.sessionLogs.reversed.toList();

        return Scaffold(
          backgroundColor: AppTheme.bgPrimary,
          body: Column(
            children: [
              AppHeader(
                title: 'Parent Portal',
                showBack: true,
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  children: [
                    if (appState.childName.isNotEmpty) ...[
                      ClayCard(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: AppTheme.pastelPeach,
                              radius: 24,
                              child: Icon(Icons.person_rounded, color: AppTheme.textMain),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appState.childName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: AppTheme.textMain,
                                  ),
                                ),
                                Text(
                                  'Age Group: ${appState.childAgeGroup.isNotEmpty ? appState.childAgeGroup : "Not Set"}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.textMuted,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                    const Text(
                      'Recent Sessions',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textMain,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (logs.isEmpty)
                      const ClayCard(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: Text(
                              'No sessions recorded yet.\nStart training to see logs here!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textMuted,
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      ...logs.map((log) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: ClayCard(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${log.moduleId.toUpperCase()} - Level ${int.tryParse(log.levelId) != null ? int.parse(log.levelId) + 1 : log.levelId}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        color: AppTheme.textMain,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: log.passed
                                            ? const Color(0xFFC8E6C9)
                                            : const Color(0xFFFFCDD2),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: AppTheme.borderDark,
                                          width: 2,
                                        ),
                                      ),
                                      child: Text(
                                        log.passed ? 'PASSED' : 'TRY AGAIN',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 12,
                                          color: log.passed
                                              ? const Color(0xFF2E7D32)
                                              : AppTheme.errorRed,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Score: ${log.score} / ${log.total}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textMain,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${log.timestamp.day}/${log.timestamp.month}/${log.timestamp.year} at ${log.timestamp.hour.toString().padLeft(2, '0')}:${log.timestamp.minute.toString().padLeft(2, '0')}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.textMuted,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
