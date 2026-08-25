import 'package:flutter/material.dart';
import '../models/skill.dart';
import '../services/local_storage_service.dart';
import '../utils/constants.dart';

class SkillProvider extends ChangeNotifier {
  List<Skill> _skills = [];

  List<Skill> get skills => _skills;
  int get totalSkills => _skills.length;

  // Skills grouped by category
  Map<String, List<Skill>> get skillsByCategory {
    final Map<String, List<Skill>> grouped = {};
    for (final skill in _skills) {
      grouped.putIfAbsent(skill.category, () => []).add(skill);
    }
    // Sort each group by proficiency descending
    grouped.forEach((key, list) {
      list.sort((a, b) =>
          b.proficiencyPercentage.compareTo(a.proficiencyPercentage));
    });
    return grouped;
  }

  // Top skills by proficiency
  List<Skill> get topSkills {
    final sorted = List<Skill>.from(_skills)
      ..sort((a, b) =>
          b.proficiencyPercentage.compareTo(a.proficiencyPercentage));
    return sorted.take(5).toList();
  }

  // Average proficiency percentage
  double get averageProficiency {
    if (_skills.isEmpty) return 0.0;
    final total =
        _skills.fold<double>(0, (sum, s) => sum + s.proficiencyPercentage);
    return total / _skills.length;
  }

  Future<void> loadSkills() async {
    _skills = LocalStorageService().loadSkills();
    notifyListeners();
  }

  Future<void> addSkill(Skill skill) async {
    _skills.add(skill);
    await _persist();
    notifyListeners();
  }

  Future<void> updateSkill(Skill updated) async {
    final index = _skills.indexWhere((s) => s.id == updated.id);
    if (index != -1) {
      _skills[index] = updated;
      await _persist();
      notifyListeners();
    }
  }

  Future<void> deleteSkill(String id) async {
    _skills.removeWhere((s) => s.id == id);
    await _persist();
    notifyListeners();
  }

  Future<void> _persist() async {
    await LocalStorageService().saveSkills(_skills);
  }

  Future<void> clearAll() async {
    _skills = [];
    notifyListeners();
  }

  Skill? getSkillById(String id) {
    try {
      return _skills.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  bool skillExists(String name, {String? excludeId}) {
    return _skills.any((s) =>
        s.name.toLowerCase() == name.toLowerCase() && s.id != excludeId);
  }
}
