import 'package:flutter/material.dart';
import '../providers/app_state_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/clay_button.dart';
import 'dashboard_screen.dart';

class VictoryScreen extends StatelessWidget {
  final AppStateProvider appState;

  const VictoryScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFD700),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // Castle / Trophy Circle
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.borderDark, width: 6),
                  boxShadow: const [
                    BoxShadow(
                      color: AppTheme.borderDark,
                      offset: Offset(0, 8),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.castle_rounded,
                  size: 80,
                  color: AppTheme.textMain,
                ),
              ),
              const SizedBox(height: 32),

              // Title
              const Text(
                'YOU WIN!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textMain,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      color: Colors.white,
                      offset: Offset(2, 2),
                      blurRadius: 0,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'You reached the castle and completed all the games!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textMain,
                ),
              ),
              const Spacer(),

              // Back to map
              ClayButton(
                isFullWidth: true,
                height: 58,
                backgroundColor: Colors.white,
                text: 'BACK TO MAP',
                fontSize: 20,
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => DashboardScreen(appState: appState),
                    ),
                    (route) => false,
                  );
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
