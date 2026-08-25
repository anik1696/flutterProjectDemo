import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // ── Palette (matches friend's app aesthetic) ───────────────────────────────
  static const Color scaffoldBg  = Color(0xFFF2F2F7); // iOS-style light gray
  static const Color cardBg      = Color(0xFFFFFFFF);
  static const Color primary     = Color(0xFF2E7D32); // Forest Green (accent only)
  static const Color textPrimary = Color(0xFF1C1C1E); // Near-black
  static const Color textSecond  = Color(0xFF8E8E93); // Medium gray
  static const Color divider     = Color(0xFFE5E5EA);

  // Semantic
  static const Color success  = Color(0xFF34C759); // iOS Green
  static const Color warning  = Color(0xFFFF9500); // iOS Orange  
  static const Color danger   = Color(0xFFFF3B30); // iOS Red
  static const Color info     = Color(0xFF007AFF); // iOS Blue
  static const Color purple   = Color(0xFF5856D6); // iOS Purple

  // Pastel icon circle backgrounds
  static const Color iconBgBlue   = Color(0xFFE3F2FD);
  static const Color iconBgGreen  = Color(0xFFE8F5E9);
  static const Color iconBgOrange = Color(0xFFFFF3E0);
  static const Color iconBgRed    = Color(0xFFFFEBEE);
  static const Color iconBgPurple = Color(0xFFEDE7F6);
  static const Color iconBgTeal   = Color(0xFFE0F2F1);

  static BoxDecoration get cardDecoration => BoxDecoration(
    color: cardBg,
    borderRadius: BorderRadius.circular(16),
    boxShadow: const [
      BoxShadow(
        color: Color(0x0D000000),
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
    ],
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: scaffoldBg,
      colorScheme: const ColorScheme.light(
        primary: primary,
        onPrimary: Colors.white,
        secondary: info,
        onSecondary: Colors.white,
        surface: cardBg,
        onSurface: textPrimary,
        error: danger,
        outline: divider,
        surfaceContainerHighest: Color(0xFFF2F2F7),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: scaffoldBg,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: const DividerThemeData(
        color: divider,
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: divider),
        ),
        labelStyle: const TextStyle(
          color: textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cardBg,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: selected ? primary : textSecond,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? primary : textSecond,
            size: 26,
          );
        }),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: const Color(0xFF1C1C1E), // iOS dark bg
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF30D158), // iOS dark green
        onPrimary: Colors.white,
        secondary: Color(0xFF0A84FF), // iOS dark blue
        onSecondary: Colors.white,
        surface: Color(0xFF2C2C2E), // iOS dark card
        onSurface: Color(0xFFFFFFFF),
        error: Color(0xFFFF453A),
        outline: Color(0xFF38383A),
        surfaceContainerHighest: Color(0xFF3A3A3C),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1C1C1E),
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF2C2C2E),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: const DividerThemeData(color: Color(0xFF38383A), thickness: 1, space: 1),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF2C2C2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF38383A)),
        ),
        labelStyle: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF2C2C2E),
        elevation: 0,
        indicatorColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: selected ? const Color(0xFF30D158) : const Color(0xFF8E8E93),
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? const Color(0xFF30D158) : const Color(0xFF8E8E93),
            size: 26,
          );
        }),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF30D158),
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2C2C2E),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF38383A)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF38383A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF30D158), width: 2),
        ),
      ),
    );
  }


  // ── Semantic helpers ───────────────────────────────────────────────────────
  static Color statusColor(String status) {
    if (status == 'Completed') return success;
    if (status == 'In Progress') return warning;
    if (status == 'Archived') return textSecond;
    return textSecond;
  }

  static Color statusBg(String status) =>
      statusColor(status).withValues(alpha: 0.12);

  static Color proficiencyColor(String level) {
    switch (level) {
      case 'Beginner':     return info;
      case 'Intermediate': return warning;
      case 'Advanced':     return success;
      case 'Expert':       return purple;
      default:             return primary;
    }
  }

  static Color proficiencyBg(String level) =>
      proficiencyColor(level).withValues(alpha: 0.12);

  // Category icon colors (for icon circles)
  static Color categoryIconColor(String category) {
    switch (category.toLowerCase()) {
      case 'freelance':         return info;
      case 'open source':      return success;
      case 'personal':         return purple;
      case 'framework':        return info;
      case 'programming language': return orange;
      case 'backend':          return warning;
      case 'database':         return danger;
      case 'cloud & devops':   return teal;
      case 'tool':             return textSecond;
      default:                 return primary;
    }
  }

  static Color categoryIconBg(String category) =>
      categoryIconColor(category).withValues(alpha: 0.12);

  static const Color orange = Color(0xFFFF6B35);
  static const Color teal   = Color(0xFF00897B);
}
