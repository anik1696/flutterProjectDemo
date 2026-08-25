import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // ── Minimalist Brand Colors ───────────────────────────────────────────────
  static const Color _primaryLight = Color(0xFF0F172A); // Slate 900
  static const Color _primaryDark  = Color(0xFFF8FAFC); // Slate 50

  static const Color _accentBlue   = Color(0xFF2563EB); // Royal Blue
  static const Color _successGreen = Color(0xFF059669); // Emerald
  static const Color _warningAmber = Color(0xFFD97706); // Amber
  static const Color _errorRed     = Color(0xFFDC2626); // Red

  // ── Light Theme ─────────────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter', // Or system font if Inter isn't in pubspec, Flutter will fallback to Roboto cleanly
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      colorScheme: const ColorScheme.light(
        primary: _primaryLight,
        onPrimary: Colors.white,
        secondary: _accentBlue,
        onSecondary: Colors.white,
        surface: Colors.white,
        onSurface: _primaryLight,
        error: _errorRed,
        outline: Color(0xFFE2E8F0),
        surfaceContainerHighest: Color(0xFFF1F5F9), // subtle background
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: _primaryLight,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: _primaryLight,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE2E8F0),
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFF1F5F9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        labelStyle: const TextStyle(
          color: Color(0xFF475569),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 0,
        indicatorColor: const Color(0xFFF1F5F9),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _primaryLight,
            );
          }
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF64748B),
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: _primaryLight, size: 24);
          }
          return const IconThemeData(color: Color(0xFF64748B), size: 24);
        }),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _primaryLight,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }

  // ── Dark Theme ──────────────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: const Color(0xFF0F172A), // Slate 900
      colorScheme: const ColorScheme.dark(
        primary: _primaryDark,
        onPrimary: _primaryLight,
        secondary: _accentBlue,
        onSecondary: Colors.white,
        surface: Color(0xFF1E293B), // Slate 800
        onSurface: _primaryDark,
        error: _errorRed,
        outline: Color(0xFF334155), // Slate 700
        surfaceContainerHighest: Color(0xFF334155),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0F172A),
        foregroundColor: _primaryDark,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: _primaryDark,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E293B),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF334155), width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF334155),
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF334155),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: const BorderSide(color: Color(0xFF475569)),
        ),
        labelStyle: const TextStyle(
          color: Color(0xFFCBD5E1),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        indicatorColor: const Color(0xFF334155),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            );
          }
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF94A3B8),
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: Colors.white, size: 24);
          }
          return const IconThemeData(color: Color(0xFF94A3B8), size: 24);
        }),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.white,
        foregroundColor: _primaryLight,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }

  // ── Semantic Colors ────────────────────────────────────────────────────────
  static Color statusColor(String status, ColorScheme scheme) {
    if (status == 'Completed') return _successGreen;
    if (status == 'In Progress') return _warningAmber;
    return scheme.onSurfaceVariant;
  }
  
  static Color statusBackgroundColor(String status, ColorScheme scheme) {
    if (status == 'Completed') return _successGreen.withValues(alpha: 0.1);
    if (status == 'In Progress') return _warningAmber.withValues(alpha: 0.1);
    return scheme.onSurfaceVariant.withValues(alpha: 0.1);
  }

  static Color proficiencyColor(String level, ColorScheme scheme) {
    switch (level) {
      case 'Beginner': return const Color(0xFF64748B);
      case 'Intermediate': return const Color(0xFF3B82F6);
      case 'Advanced': return const Color(0xFF10B981);
      case 'Expert': return const Color(0xFF8B5CF6);
      default: return scheme.primary;
    }
  }

  // Fallbacks for code that expects gradients
  static LinearGradient heroGradient(ColorScheme cs) => LinearGradient(
    colors: [cs.surface, cs.surface], // Flat fallback
  );
  static LinearGradient cardGradient(Color color) => LinearGradient(
    colors: [color, color], // Flat fallback
  );
}
