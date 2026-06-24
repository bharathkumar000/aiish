import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'providers/app_state_provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/onboarding_screen.dart';
import 'services/audio_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientation for mobile training
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Pre-initialize audio service
  await AudioService().init();

  runApp(const AiishApp());
}

class AiishApp extends StatefulWidget {
  const AiishApp({super.key});

  @override
  State<AiishApp> createState() => _AiishAppState();
}

class _AiishAppState extends State<AiishApp> {
  final AppStateProvider _appState = AppStateProvider();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appState,
      builder: (context, _) {
        if (!_appState.isLoaded) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: AppTheme.bgPrimary,
              body: Center(
                child: CircularProgressIndicator(color: AppTheme.primaryDark),
              ),
            ),
          );
        }

        return MaterialApp(
          title: 'AIISH Auditory Closure Training',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.themeData,
          home: _appState.childName.isEmpty
              ? OnboardingScreen(appState: _appState)
              : DashboardScreen(appState: _appState),
        );
      },
    );
  }
}
