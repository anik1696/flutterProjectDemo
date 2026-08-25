import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/project_provider.dart';
import '../providers/skill_provider.dart';
import '../utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Shorter delay for a professional feel
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    await context.read<ThemeProvider>().loadTheme();
    await context.read<ProfileProvider>().loadProfile();
    await context.read<ProjectProvider>().loadProjects();
    await context.read<SkillProvider>().loadSkills();

    if (!mounted) return;

    final profileProvider = context.read<ProfileProvider>();
    final isProfileSetup = profileProvider.isProfileSetup;

    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      isProfileSetup ? kRouteMain : kRouteOnboarding,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.layers_rounded, size: 64, color: cs.primary),
            const SizedBox(height: 24),
            Text(
              'CodeFolio',
              style: tt.headlineMedium?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
