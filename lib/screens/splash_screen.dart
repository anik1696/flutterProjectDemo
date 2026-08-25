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
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;
    await context.read<ThemeProvider>().loadTheme();
    await context.read<ProfileProvider>().loadProfile();
    await context.read<ProjectProvider>().loadProjects();
    await context.read<SkillProvider>().loadSkills();
    if (!mounted) return;
    final isProfileSetup = context.read<ProfileProvider>().isProfileSetup;
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, isProfileSetup ? kRouteMain : kRouteOnboarding);
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.layers_rounded, color: Colors.white, size: 48),
            ),
            const SizedBox(height: 24),
            Text(
              'CodeFolio',
              style: tt.headlineMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Your dev portfolio tracker',
              style: tt.bodyMedium?.copyWith(color: AppTheme.textSecond),
            ),
          ],
        ),
      ),
    );
  }
}
