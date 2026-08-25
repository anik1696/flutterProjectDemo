import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/project_provider.dart';
import '../providers/skill_provider.dart';
import '../utils/constants.dart';
import '../app/theme.dart';

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
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(Icons.layers_rounded, size: 64, color: AppTheme.primary),
            ),
            const SizedBox(height: 32),
            Text(
              'CodeFolio',
              style: tt.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
