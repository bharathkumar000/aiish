import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../providers/app_state_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/clay_button.dart';
import '../widgets/clay_card.dart';

class TherapistPortalScreen extends StatefulWidget {
  final AppStateProvider appState;

  const TherapistPortalScreen({super.key, required this.appState});

  @override
  State<TherapistPortalScreen> createState() => _TherapistPortalScreenState();
}

class _TherapistPortalScreenState extends State<TherapistPortalScreen> {
  late double _threshold;
  late int _maxReplays;
  late bool _clueAudioEnabled;
  late bool _visualClueEnabled;

  @override
  void initState() {
    super.initState();
    final config = widget.appState.therapistConfig;
    _threshold = config.passThreshold.toDouble();
    _maxReplays = config.maxAudioReplays;
    _clueAudioEnabled = config.clueAudioEnabled;
    _visualClueEnabled = config.visualClueEnabled;
  }

  void _saveSettings() async {
    final newConfig = TherapistConfig(
      passThreshold: _threshold.round(),
      maxAudioReplays: _maxReplays,
      clueAudioEnabled: _clueAudioEnabled,
      visualClueEnabled: _visualClueEnabled,
    );
    await widget.appState.updateTherapistConfig(newConfig);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Therapist configuration saved successfully!'),
        backgroundColor: Color(0xFF2E7D32),
      ),
    );
  }

  void _confirmResetProgress() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppTheme.borderDark, width: 4),
        ),
        title: const Text(
          'Reset All Progress?',
          style: TextStyle(fontWeight: FontWeight.w900, color: AppTheme.textMain),
        ),
        content: const Text(
          'This will lock all modules and levels back to initial state and delete all recorded sessions.',
          style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.textMain),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('CANCEL', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await widget.appState.resetAllProgress();
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All progress and logs have been reset.')),
              );
            },
            child: const Text('RESET ALL', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.appState,
      builder: (context, _) {
        final logsJson = const JsonEncoder.withIndent('  ').convert(
          widget.appState.sessionLogs.map((l) => l.toJson()).toList(),
        );

        return Scaffold(
          backgroundColor: AppTheme.bgPrimary,
          body: Column(
            children: [
              AppHeader(
                title: 'Therapist Portal',
                showBack: true,
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  children: [
                    // Configuration Card
                    ClayCard(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Clinical Configuration',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.textMain,
                            ),
                          ),
                          const SizedBox(height: 16),

                          Text(
                            'Pass Threshold: ${_threshold.round()}%',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textMain,
                            ),
                          ),
                          Slider(
                            value: _threshold,
                            min: 50,
                            max: 100,
                            divisions: 10,
                            activeColor: AppTheme.primaryDark,
                            inactiveColor: Colors.grey.shade300,
                            label: '${_threshold.round()}%',
                            onChanged: (val) => setState(() => _threshold = val),
                          ),
                          const SizedBox(height: 12),

                          Text(
                            'Max Audio Replays per Trial: $_maxReplays',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textMain,
                            ),
                          ),
                          Slider(
                            value: _maxReplays.toDouble(),
                            min: 1,
                            max: 5,
                            divisions: 4,
                            activeColor: AppTheme.secondaryDark,
                            inactiveColor: Colors.grey.shade300,
                            label: '$_maxReplays',
                            onChanged: (val) => setState(() => _maxReplays = val.round()),
                          ),
                          const SizedBox(height: 12),

                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text(
                              'Enable Audio Clues',
                              style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textMain),
                            ),
                            value: _clueAudioEnabled,
                            activeThumbColor: Colors.white,
                            activeTrackColor: AppTheme.primary,
                            onChanged: (val) => setState(() => _clueAudioEnabled = val),
                          ),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text(
                              'Enable Visual Clues',
                              style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textMain),
                            ),
                            value: _visualClueEnabled,
                            activeThumbColor: Colors.white,
                            activeTrackColor: AppTheme.primary,
                            onChanged: (val) => setState(() => _visualClueEnabled = val),
                          ),
                          const SizedBox(height: 16),

                          ClayButton(
                            isFullWidth: true,
                            height: 50,
                            backgroundColor: AppTheme.primary,
                            text: 'SAVE SETTINGS',
                            fontSize: 16,
                            onPressed: _saveSettings,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Logs Inspection Card
                    ClayCard(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Detailed Clinical Logs',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.textMain,
                                ),
                              ),
                              Text(
                                '${widget.appState.sessionLogs.length} Sessions',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textMuted,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          Container(
                            height: 200,
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2B2B2B),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.borderDark, width: 2),
                            ),
                            child: SingleChildScrollView(
                              child: Text(
                                logsJson.isEmpty || logsJson == '[]'
                                    ? '// No session logs recorded yet.'
                                    : logsJson,
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                  color: Color(0xFF66BB6A),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),

                          ClayButton(
                            isFullWidth: true,
                            height: 50,
                            backgroundColor: AppTheme.errorRed,
                            textColor: Colors.white,
                            text: 'RESET ALL PROGRESS',
                            fontSize: 16,
                            onPressed: _confirmResetProgress,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
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
