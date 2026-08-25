import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/main_screen.dart';
import '../screens/project_details_screen.dart';
import '../screens/add_edit_project_screen.dart';
import '../screens/settings_screen.dart';
import '../models/project.dart';

class AppRoutes {
  AppRoutes._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case kRouteSplash:
        return _fadeRoute(const SplashScreen(), settings);

      case kRouteOnboarding:
        return _slideRoute(const OnboardingScreen(), settings);

      case kRouteMain:
        final index = settings.arguments as int? ?? 0;
        return _fadeRoute(MainScreen(initialIndex: index), settings);

      case kRouteProjectDetails:
        final project = settings.arguments as Project;
        return _slideRoute(ProjectDetailsScreen(project: project), settings);

      case kRouteAddProject:
        return _slideRoute(
          const AddEditProjectScreen(project: null),
          settings,
        );

      case kRouteEditProject:
        final project = settings.arguments as Project;
        return _slideRoute(
          AddEditProjectScreen(project: project),
          settings,
        );

      case kRouteSettings:
        return _slideRoute(const SettingsScreen(), settings);

      default:
        return _fadeRoute(const SplashScreen(), settings);
    }
  }

  static PageRouteBuilder _fadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 250),
    );
  }

  static PageRouteBuilder _slideRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final tween = Tween(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOut));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
