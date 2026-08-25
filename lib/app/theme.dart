import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // ── Vibrant Professional Palette ─────────────────────────────────────────
  static const Color primary = Color(0xFF4338CA); // Deep Indigo
  static const Color secondary = Color(0xFFF43F5E); // Rose
  static const Color background = Color(0xFFF1F5F9); // Soft Blue-Gray
  static const Color cardColor = Colors.white;
  static const Color textDark = Color(0xFF1E293B); // Slate 800
  static const Color textLight = Color(0xFF64748B); // Slate 500

  // Semantic
  static const Color success = Color(0xFF10B981); // Emerald
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color info = Color(0xFF0EA5E9); // Sky Blue

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.light(
        primary: primary,
        onPrimary: Colors.white,
        secondary: secondary,
        onSecondary: Colors.white,
        surface: background,
        onSurface: textDark,
        error: secondary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 4, // Real shadow for physical depth
        shadowColor: const Color(0x1A000000), // Soft shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide.none,
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE2E8F0),
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFEEF2FF), // Light indigo
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide.none,
        ),
        labelStyle: const TextStyle(
          color: primary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 16,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        indicatorColor: const Color(0xFFEEF2FF),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: primary,
            );
          }
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textLight,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primary, size: 26);
          }
          return const IconThemeData(color: textLight, size: 24);
        }),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: secondary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  }

  static ThemeData get darkTheme => lightTheme;

  // Colorful Semantic Helpers
  static Color statusColor(String status) {
    if (status == 'Completed') return success;
    if (status == 'In Progress') return warning;
    return textLight;
  }
  
  static Color statusBackgroundColor(String status) {
    if (status == 'Completed') return success.withValues(alpha: 0.15);
    if (status == 'In Progress') return warning.withValues(alpha: 0.15);
    return textLight.withValues(alpha: 0.15);
  }

  static Color proficiencyColor(String level) {
    switch (level) {
      case 'Beginner': return info;
      case 'Intermediate': return warning;
      case 'Advanced': return success;
      case 'Expert': return secondary;
      default: return primary;
    }
  }

  static Color proficiencyBgColor(String level) {
    return proficiencyColor(level).withValues(alpha: 0.15);
  }
}
