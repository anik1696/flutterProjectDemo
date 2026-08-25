import 'package:flutter/material.dart';
import '../models/project.dart';
import '../services/local_storage_service.dart';
import '../utils/constants.dart';

class ProjectProvider extends ChangeNotifier {
  List<Project> _projects = [];
  String _searchQuery = '';
  String _statusFilter = 'All';
  String _technologyFilter = 'All';

  List<Project> get projects => _projects;
  String get searchQuery => _searchQuery;
  String get statusFilter => _statusFilter;
  String get technologyFilter => _technologyFilter;

  // Statistics
  int get totalProjects => _projects.length;
  int get completedProjects =>
      _projects.where((p) => p.status == kStatusCompleted).length;
  int get inProgressProjects =>
      _projects.where((p) => p.status == kStatusInProgress).length;
  int get archivedProjects =>
      _projects.where((p) => p.status == kStatusArchived).length;

  // Filtered & searched projects
  List<Project> get filteredProjects {
    List<Project> result = List.from(_projects);

    // Status filter
    if (_statusFilter != 'All') {
      result = result.where((p) => p.status == _statusFilter).toList();
    }

    // Technology filter
    if (_technologyFilter != 'All') {
      result = result
          .where((p) => p.technologies
              .any((t) => t.toLowerCase() == _technologyFilter.toLowerCase()))
          .toList();
    }

    // Search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result.where((p) {
        return p.title.toLowerCase().contains(query) ||
            p.description.toLowerCase().contains(query) ||
            p.category.toLowerCase().contains(query) ||
            p.technologies.any((t) => t.toLowerCase().contains(query));
      }).toList();
    }

    // Sort: newest first
    result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return result;
  }

  // All unique technologies across all projects
  List<String> get allTechnologies {
    final techs = <String>{};
    for (final p in _projects) {
      techs.addAll(p.technologies);
    }
    final sorted = techs.toList()..sort();
    return sorted;
  }

  // Recent projects (last 3)
  List<Project> get recentProjects {
    final sorted = List<Project>.from(_projects)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(3).toList();
  }

  Future<void> loadProjects() async {
    _projects = LocalStorageService().loadProjects();
    notifyListeners();
  }

  Future<void> addProject(Project project) async {
    _projects.add(project);
    await _persist();
    notifyListeners();
  }

  Future<void> updateProject(Project updated) async {
    final index = _projects.indexWhere((p) => p.id == updated.id);
    if (index != -1) {
      _projects[index] = updated;
      await _persist();
      notifyListeners();
    }
  }

  Future<void> deleteProject(String id) async {
    _projects.removeWhere((p) => p.id == id);
    await _persist();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setStatusFilter(String status) {
    _statusFilter = status;
    notifyListeners();
  }

  void setTechnologyFilter(String technology) {
    _technologyFilter = technology;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _statusFilter = 'All';
    _technologyFilter = 'All';
    notifyListeners();
  }

  Future<void> _persist() async {
    await LocalStorageService().saveProjects(_projects);
  }

  Future<void> clearAll() async {
    _projects = [];
    _searchQuery = '';
    _statusFilter = 'All';
    _technologyFilter = 'All';
    notifyListeners();
  }

  Project? getProjectById(String id) {
    try {
      return _projects.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
