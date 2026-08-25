import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // ── Brand Colors ────────────────────────────────────────────────────────────
  static const Color _seedIndigo = Color(0xFF4F46E5);   // Primary
  static const Color _seedCyan   = Color(0xFF06B6D4);   // Accent / Tertiary
  static const Color _successGreen = Color(0xFF10B981);
  static const Color _warningAmber = Color(0xFFF59E0B);
  static const Color _errorRed    = Color(0xFFEF4444);

  static const Color _darkBg       = Color(0xFF0F0F1A);
  static const Color _darkSurface  = Color(0xFF1A1A2E);
  static const Color _darkCard     = Color(0xFF16213E);

  // ── Light Theme ─────────────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedIndigo,
      brightness: Brightness.light,
      secondary: _seedCyan,
    ).copyWith(
      tertiary: _seedCyan,
      error: _errorRed,
    );
    return _buildTheme(colorScheme);
  }

  // ── Dark Theme ──────────────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedIndigo,
      brightness: Brightness.dark,
      secondary: _seedCyan,
    ).copyWith(
      surface: _darkSurface,
      surfaceContainerLow: _darkCard,
      surfaceContainer: _darkCard,
      surfaceContainerHigh: Color(0xFF1E1E3A),
      surfaceContainerHighest: Color(0xFF252540),
      tertiary: _seedCyan,
      error: _errorRed,
    );
    return _buildTheme(colorScheme);
  }

  // ── Shared Theme Builder ────────────────────────────────────────────────────
  static ThemeData _buildTheme(ColorScheme cs) {
    final isDark = cs.brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      fontFamily: 'Roboto',

      // ── Scaffold ─────────────────────────────────────────────────────────────
      scaffoldBackgroundColor: isDark ? _darkBg : const Color(0xFFF5F5FF),

      // ── AppBar ───────────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: cs.onSurface,
        titleTextStyle: TextStyle(
          color: cs.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),

      // ── Cards ────────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : cs.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        color: isDark ? _darkCard : cs.surface,
      ),

      // ── Input Fields ─────────────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : cs.surfaceContainerHighest.withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : cs.outline.withValues(alpha: 0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : cs.outline.withValues(alpha: 0.25),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cs.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: _errorRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: _errorRed, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: TextStyle(color: cs.onSurfaceVariant),
        hintStyle: TextStyle(color: cs.onSurfaceVariant.withValues(alpha: 0.6)),
      ),

      // ── Buttons ──────────────────────────────────────────────────────────────
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),

      // ── Chips ────────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),

      // ── Bottom Navigation Bar ────────────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        height: 68,
        elevation: 0,
        backgroundColor: isDark
            ? _darkSurface.withValues(alpha: 0.95)
            : cs.surface.withValues(alpha: 0.95),
        indicatorColor: cs.primary.withValues(alpha: 0.15),
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: cs.primary,
            );
          }
          return TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: cs.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: cs.primary, size: 22);
          }
          return IconThemeData(color: cs.onSurfaceVariant, size: 22);
        }),
      ),

      // ── FAB ──────────────────────────────────────────────────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
      ),

      // ── Dialogs ──────────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 8,
        backgroundColor: isDark ? _darkCard : cs.surface,
      ),

      // ── SnackBar ─────────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: isDark ? const Color(0xFF2D2D4E) : cs.inverseSurface,
      ),

      // ── Progress ─────────────────────────────────────────────────────────────
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: cs.primary,
        linearTrackColor: cs.primary.withValues(alpha: 0.15),
        linearMinHeight: 6,
      ),

      // ── Divider ──────────────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : cs.outline.withValues(alpha: 0.2),
        thickness: 1,
        space: 1,
      ),

      // ── ListTile ─────────────────────────────────────────────────────────────
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  // ── Semantic Color Helpers ──────────────────────────────────────────────────

  static Color statusColor(String status, ColorScheme scheme) {
    switch (status) {
      case 'Completed':  return _successGreen;
      case 'In Progress': return _warningAmber;
      case 'Archived':   return scheme.onSurfaceVariant;
      default:           return scheme.onSurfaceVariant;
    }
  }

  static Color statusBackgroundColor(String status, ColorScheme scheme) {
    switch (status) {
      case 'Completed':  return _successGreen.withValues(alpha: 0.12);
      case 'In Progress': return _warningAmber.withValues(alpha: 0.12);
      case 'Archived':   return scheme.onSurfaceVariant.withValues(alpha: 0.1);
      default:           return scheme.onSurfaceVariant.withValues(alpha: 0.1);
    }
  }

  static Color proficiencyColor(String level, ColorScheme scheme) {
    switch (level) {
      case 'Beginner':     return const Color(0xFF60A5FA);  // Blue-400
      case 'Intermediate': return _warningAmber;
      case 'Advanced':     return _successGreen;
      case 'Expert':       return scheme.primary;
      default:             return scheme.primary;
    }
  }

  // ── Gradient Presets ────────────────────────────────────────────────────────

  static LinearGradient heroGradient(ColorScheme cs) => LinearGradient(
    colors: [_seedIndigo, _seedCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient cardGradient(Color color) => LinearGradient(
    colors: [color.withValues(alpha: 0.8), color.withValues(alpha: 0.4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
