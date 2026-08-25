import 'package:flutter/foundation.dart';

/// Represents a portfolio project with metadata, status, and notes.
class Project {
  final String id;
  final String title;
  final String description;
  final String category;
  final String githubUrl;
  final String liveDemoUrl;
  final List<String> technologies;

  /// One of: 'In Progress', 'Completed', 'Archived'
  final String status;

  final DateTime? startDate;
  final DateTime? targetDate;
  final String milestone;
  final String architectureNotes;
  final String featureNotes;
  final DateTime createdAt;

  const Project({
    required this.id,
    required this.title,
    required this.description,
    this.category = '',
    this.githubUrl = '',
    this.liveDemoUrl = '',
    this.technologies = const [],
    this.status = 'In Progress',
    this.startDate,
    this.targetDate,
    this.milestone = '',
    this.architectureNotes = '',
    this.featureNotes = '',
    required this.createdAt,
  });

  /// Creates a [Project] from a JSON map. Handles null dates gracefully.
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      githubUrl: json['githubUrl'] as String? ?? '',
      liveDemoUrl: json['liveDemoUrl'] as String? ?? '',
      technologies: (json['technologies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      status: json['status'] as String? ?? 'In Progress',
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'] as String)
          : null,
      targetDate: json['targetDate'] != null
          ? DateTime.tryParse(json['targetDate'] as String)
          : null,
      milestone: json['milestone'] as String? ?? '',
      architectureNotes: json['architectureNotes'] as String? ?? '',
      featureNotes: json['featureNotes'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  /// Serialises this [Project] to a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'githubUrl': githubUrl,
      'liveDemoUrl': liveDemoUrl,
      'technologies': technologies,
      'status': status,
      'startDate': startDate?.toIso8601String(),
      'targetDate': targetDate?.toIso8601String(),
      'milestone': milestone,
      'architectureNotes': architectureNotes,
      'featureNotes': featureNotes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Returns a copy of this [Project] with the given fields replaced.
  /// Use the [_Sentinel] pattern to allow nullable fields to be explicitly
  /// set to null via [copyWith].
  Project copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? githubUrl,
    String? liveDemoUrl,
    List<String>? technologies,
    String? status,
    Object? startDate = _sentinel,
    Object? targetDate = _sentinel,
    String? milestone,
    String? architectureNotes,
    String? featureNotes,
    DateTime? createdAt,
  }) {
    return Project(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      githubUrl: githubUrl ?? this.githubUrl,
      liveDemoUrl: liveDemoUrl ?? this.liveDemoUrl,
      technologies: technologies ?? this.technologies,
      status: status ?? this.status,
      startDate:
          startDate == _sentinel ? this.startDate : startDate as DateTime?,
      targetDate:
          targetDate == _sentinel ? this.targetDate : targetDate as DateTime?,
      milestone: milestone ?? this.milestone,
      architectureNotes: architectureNotes ?? this.architectureNotes,
      featureNotes: featureNotes ?? this.featureNotes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Generates a unique ID based on the current time in milliseconds.
  static String generateId() =>
      DateTime.now().millisecondsSinceEpoch.toString();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Project &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Project(id: $id, title: $title, status: $status)';
}

// Private sentinel used in copyWith to distinguish "not provided" from explicit null.
const Object _sentinel = Object();
