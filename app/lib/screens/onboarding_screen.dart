import 'package:flutter/material.dart';
import '../providers/app_state_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/clay_button.dart';
import '../widgets/clay_card.dart';
import 'dashboard_screen.dart';
import 'parent_portal_screen.dart';
import 'therapist_portal_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final AppStateProvider appState;
  const OnboardingScreen({super.key, required this.appState});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final TextEditingController _nameController;
  String _selectedAgeGroup = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.appState.childName);
    _selectedAgeGroup = widget.appState.childAgeGroup.isNotEmpty
        ? widget.appState.childAgeGroup
        : '7-9';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleStart() async {
    final name = _nameController.text.trim();
    if (name.isNotEmpty && _selectedAgeGroup.isNotEmpty) {
      await widget.appState.setChildInfo(name, _selectedAgeGroup);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => DashboardScreen(appState: widget.appState),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isValid = _nameController.text.trim().isNotEmpty && _selectedAgeGroup.isNotEmpty;

    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Action Row (Parent & Therapist Portals shortcut)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    tooltip: 'Parent Insights',
                    icon: const Icon(Icons.family_restroom_rounded, color: AppTheme.textMain, size: 28),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ParentPortalScreen(appState: widget.appState),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    tooltip: 'Therapist Management',
                    icon: const Icon(Icons.medical_services_rounded, color: AppTheme.textMain, size: 28),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => TherapistPortalScreen(appState: widget.appState),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Welcome Title
              const Text(
                'Welcome!',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.primaryDark,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'AIISH Auditory Closure Training',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),

              // Form Card
              ClayCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Child's Name",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textMain,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nameController,
                      onChanged: (_) => setState(() {}),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppTheme.textMain,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter name...',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppTheme.borderDark, width: 2.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      'Age Group',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textMain,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: ClayButton(
                            height: 48,
                            backgroundColor: _selectedAgeGroup == '7-9'
                                ? AppTheme.primary
                                : Colors.grey.shade200,
                            textColor: _selectedAgeGroup == '7-9'
                                ? AppTheme.textMain
                                : Colors.grey.shade600,
                            text: '7 - 9.11 Yrs',
                            fontSize: 14,
                            onPressed: () => setState(() => _selectedAgeGroup = '7-9'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ClayButton(
                            height: 48,
                            backgroundColor: _selectedAgeGroup == '10-12'
                                ? AppTheme.primary
                                : Colors.grey.shade200,
                            textColor: _selectedAgeGroup == '10-12'
                                ? AppTheme.textMain
                                : Colors.grey.shade600,
                            text: '10 - 12 Yrs',
                            fontSize: 14,
                            onPressed: () => setState(() => _selectedAgeGroup = '10-12'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Start Button
              ClayButton(
                isFullWidth: true,
                height: 60,
                backgroundColor: AppTheme.secondary,
                text: "LET'S START!",
                fontSize: 20,
                onPressed: isValid ? _handleStart : null,
              ),
              const SizedBox(height: 32),

              // Mascot Illustration
              Image.asset(
                'assets/images/mascot.png',
                width: 160,
                height: 160,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: AppTheme.pastelPeach,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.borderDark, width: 4),
                  ),
                  child: const Icon(Icons.pets_rounded, size: 70, color: AppTheme.textMain),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
