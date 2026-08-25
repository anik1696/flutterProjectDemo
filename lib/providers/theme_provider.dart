import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import '../services/local_storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  String get themeModeString {
    switch (_themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      default:
        return 'system';
    }
  }

  Future<void> loadTheme() async {
    final stored = LocalStorageService().loadThemeMode();
    _themeMode = _parseThemeMode(stored);
    notifyListeners();
  }

  Future<void> setThemeMode(String mode) async {
    _themeMode = _parseThemeMode(mode);
    await LocalStorageService().saveThemeMode(mode);
    notifyListeners();
  }

  ThemeMode _parseThemeMode(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
