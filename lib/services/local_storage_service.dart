import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/project.dart';
import '../models/skill.dart';
import '../models/user_profile.dart';
import '../utils/constants.dart';

/// Centralized local storage service that wraps all [SharedPreferences] I/O.
///
/// Implemented as a singleton so that a single [SharedPreferences] instance is
/// shared across the entire app. Call [init] once during app startup (in main)
/// before using any other method.
class LocalStorageService {
  // ---------------------------------------------------------------------------
  // Singleton
  // ---------------------------------------------------------------------------

  static final LocalStorageService _instance = LocalStorageService._internal();

  factory LocalStorageService() => _instance;

  LocalStorageService._internal();

  // ---------------------------------------------------------------------------
  // Internal state
  // ---------------------------------------------------------------------------

  late SharedPreferences _prefs;

  // ---------------------------------------------------------------------------
  // Initialisation
  // ---------------------------------------------------------------------------

  /// Must be called once (e.g. in [main]) before any other method is used.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ---------------------------------------------------------------------------
  // Profile
  // ---------------------------------------------------------------------------

  /// Serialises [profile] to JSON and persists it.
  Future<void> saveProfile(UserProfile profile) async {
    final encoded = jsonEncode(profile.toJson());
    await _prefs.setString(kProfileKey, encoded);
  }

  /// Returns the stored [UserProfile], or `null` if none exists or the stored
  /// data cannot be decoded.
  UserProfile? loadProfile() {
    try {
      final raw = _prefs.getString(kProfileKey);
      if (raw == null || raw.isEmpty) return null;
      final Map<String, dynamic> json =
          jsonDecode(raw) as Map<String, dynamic>;
      return UserProfile.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  /// Persists whether the user has completed the initial profile-setup flow.
  Future<void> setProfileSetup(bool value) async {
    await _prefs.setBool(kIsProfileSetup, value);
  }

  /// Returns `true` when the user has completed profile setup; defaults to
  /// `false`.
  bool isProfileSetup() {
    return _prefs.getBool(kIsProfileSetup) ?? false;
  }

  // ---------------------------------------------------------------------------
  // Projects
  // ---------------------------------------------------------------------------

  /// Serialises [projects] as a JSON string and persists it.
  Future<void> saveProjects(List<Project> projects) async {
    final encoded = jsonEncode(
      projects.map((p) => p.toJson()).toList(),
    );
    await _prefs.setString(kProjectsKey, encoded);
  }

  /// Returns the stored list of [Project]s, or an empty list if none exist or
  /// the stored data cannot be decoded.
  List<Project> loadProjects() {
    try {
      final raw = _prefs.getString(kProjectsKey);
      if (raw == null || raw.isEmpty) return [];
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((item) => Project.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  // ---------------------------------------------------------------------------
  // Skills
  // ---------------------------------------------------------------------------

  /// Serialises [skills] as a JSON string and persists it.
  Future<void> saveSkills(List<Skill> skills) async {
    final encoded = jsonEncode(
      skills.map((s) => s.toJson()).toList(),
    );
    await _prefs.setString(kSkillsKey, encoded);
  }

  /// Returns the stored list of [Skill]s, or an empty list if none exist or
  /// the stored data cannot be decoded.
  List<Skill> loadSkills() {
    try {
      final raw = _prefs.getString(kSkillsKey);
      if (raw == null || raw.isEmpty) return [];
      final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((item) => Skill.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  // ---------------------------------------------------------------------------
  // Theme
  // ---------------------------------------------------------------------------

  /// Persists the theme [mode] string. Expected values: `'light'`, `'dark'`,
  /// `'system'`.
  Future<void> saveThemeMode(String mode) async {
    await _prefs.setString(kThemeModeKey, mode);
  }

  /// Returns the stored theme mode string, defaulting to `'system'` when no
  /// value has been saved yet.
  String loadThemeMode() {
    return _prefs.getString(kThemeModeKey) ?? 'system';
  }

  // ---------------------------------------------------------------------------
  // Data reset
  // ---------------------------------------------------------------------------

  /// Wipes **all** data stored by the app.
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
