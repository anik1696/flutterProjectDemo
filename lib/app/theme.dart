import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color _primarySeedLight = Color(0xFF6750A4);
  static const Color _primarySeedDark = Color(0xFF9580D1);

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primarySeedLight,
      brightness: Brightness.light,
    );
    return _buildTheme(colorScheme);
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primarySeedDark,
      brightness: Brightness.dark,
    );
    return _buildTheme(colorScheme);
  }

  static ThemeData _buildTheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: 'Roboto',
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: colorScheme.outline.withOpacity(0.12),
          ),
        ),
        color: colorScheme.surface,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.4)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        hintStyle:
            TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.7)),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant.withOpacity(0.5),
        thickness: 1,
        space: 1,
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 2,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            );
          }
          return TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurfaceVariant,
          );
        }),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 4,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.primary.withOpacity(0.15),
        linearMinHeight: 8,
      ),
    );
  }

  // Status colors (semantic, not hardcoded per widget)
  static Color statusColor(String status, ColorScheme scheme) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'In Progress':
        return Colors.orange;
      case 'Archived':
        return scheme.onSurfaceVariant;
      default:
        return scheme.onSurfaceVariant;
    }
  }

  static Color statusBackgroundColor(String status, ColorScheme scheme) {
    switch (status) {
      case 'Completed':
        return Colors.green.withOpacity(0.12);
      case 'In Progress':
        return Colors.orange.withOpacity(0.12);
      case 'Archived':
        return scheme.onSurfaceVariant.withOpacity(0.12);
      default:
        return scheme.onSurfaceVariant.withOpacity(0.12);
    }
  }

  // Proficiency colors
  static Color proficiencyColor(String level, ColorScheme scheme) {
    switch (level) {
      case 'Beginner':
        return Colors.blue;
      case 'Intermediate':
        return Colors.orange;
      case 'Advanced':
        return Colors.green;
      case 'Expert':
        return scheme.primary;
      default:
        return scheme.primary;
    }
  }
}
