import 'package:flutter/material.dart';

/// Represents a technical skill with proficiency level and years of experience.
class Skill {
  final String id;
  final String name;
  final String category;

  /// One of: 'Beginner', 'Intermediate', 'Advanced', 'Expert'
  final String proficiency;

  final double yearsExperience;
  final String notes;

  const Skill({
    required this.id,
    required this.name,
    required this.category,
    required this.proficiency,
    this.yearsExperience = 0.0,
    this.notes = '',
  });

  /// Creates a [Skill] from a JSON map.
  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      proficiency: json['proficiency'] as String? ?? 'Beginner',
      yearsExperience: (json['yearsExperience'] as num?)?.toDouble() ?? 0.0,
      notes: json['notes'] as String? ?? '',
    );
  }

  /// Serialises this [Skill] to a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'proficiency': proficiency,
      'yearsExperience': yearsExperience,
      'notes': notes,
    };
  }

  /// Returns a copy of this [Skill] with the given fields replaced.
  Skill copyWith({
    String? id,
    String? name,
    String? category,
    String? proficiency,
    double? yearsExperience,
    String? notes,
  }) {
    return Skill(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      proficiency: proficiency ?? this.proficiency,
      yearsExperience: yearsExperience ?? this.yearsExperience,
      notes: notes ?? this.notes,
    );
  }

  /// Returns a 0.0–1.0 value representing the proficiency level.
  ///
  /// Beginner=0.25 | Intermediate=0.50 | Advanced=0.75 | Expert=1.0
  double get proficiencyPercentage {
    switch (proficiency) {
      case 'Intermediate':
        return 0.50;
      case 'Advanced':
        return 0.75;
      case 'Expert':
        return 1.0;
      case 'Beginner':
      default:
        return 0.25;
    }
  }

  /// Returns a [Color] that visually represents the proficiency level.
  ///
  /// Beginner=red | Intermediate=orange | Advanced=blue | Expert=green
  Color get proficiencyColor {
    switch (proficiency) {
      case 'Intermediate':
        return Colors.orange;
      case 'Advanced':
        return Colors.blue;
      case 'Expert':
        return Colors.green;
      case 'Beginner':
      default:
        return Colors.red;
    }
  }

  /// Generates a unique ID based on the current time in milliseconds.
  static String generateId() =>
      DateTime.now().millisecondsSinceEpoch.toString();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Skill && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Skill(id: $id, name: $name, proficiency: $proficiency)';
}
