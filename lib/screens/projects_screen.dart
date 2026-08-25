import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';
import '../models/project.dart';
import '../utils/constants.dart';
import '../widgets/project_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/tech_chip.dart';

/// Full-featured projects screen with search, filter, and list view.
class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isGridView = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _hasActiveFilters(ProjectProvider provider) {
    return provider.statusFilter != 'All' ||
        provider.technologyFilter != 'All' ||
        provider.searchQuery.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        actions: [
          // Toggle list / grid label (visual only – list is always used for single-col)
          Consumer<ProjectProvider>(
            builder: (context, provider, _) => IconButton(
              icon: Icon(
                _isGridView
                    ? Icons.view_list_rounded
                    : Icons.grid_view_rounded,
              ),
              tooltip: _isGridView ? 'List view' : 'Grid view',
              onPressed: () => setState(() => _isGridView = !_isGridView),
            ),
          ),
          // Clear filters – shown only when any filter/search is active
          Consumer<ProjectProvider>(
            builder: (context, provider, _) {
              if (!_hasActiveFilters(provider)) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.filter_alt_off_rounded),
                tooltip: 'Clear filters',
                onPressed: () {
                  provider.clearFilters();
                  _searchController.clear();
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // -- Search bar -----------------------------------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Consumer<ProjectProvider>(
              builder: (context, provider, _) => TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Search projects...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close_rounded),
                          tooltip: 'Clear search',
                          onPressed: () {
                            _searchController.clear();
                            provider.setSearchQuery('');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
                onChanged: (value) {
                  setState(() {}); // Rebuild to toggle the clear icon
                  context.read<ProjectProvider>().setSearchQuery(value);
                },
              ),
            ),
          ),

          // -- Filter row -----------------------------------------------
          _buildFilterRow(context),

          // -- Project list / empty state -------------------------------
          Expanded(
            child: Consumer<ProjectProvider>(
              builder: (context, provider, _) {
                final projects = provider.filteredProjects;

                if (projects.isEmpty) {
                  return Center(
                    child: EmptyState(
                      icon: Icons.folder_open_rounded,
                      title: 'No projects found',
                      message: _hasActiveFilters(provider)
                          ? 'Try adjusting your search or filters'
                          : 'Add your first project to get started',
                      actionLabel:
                          _hasActiveFilters(provider) ? null : 'Add Project',
                      onAction: _hasActiveFilters(provider)
                          ? null
                          : () =>
                              Navigator.pushNamed(context, kRouteAddProject),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: projects.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (ctx, i) => ProjectCard(
                    project: projects[i],
                    onTap: () => Navigator.pushNamed(
                      ctx,
                      kRouteProjectDetails,
                      arguments: projects[i],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, kRouteAddProject),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Project'),
      ),
    );
  }

  /// Horizontally scrollable row of status and technology filter chips.
  Widget _buildFilterRow(BuildContext context) {
    return Consumer<ProjectProvider>(
      builder: (context, provider, _) {
        final statuses = ['All', ...kProjectStatuses];
        final technologies = provider.allTechnologies;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            children: [
              // Status filters
              ...statuses.map(
                (status) => Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: TechChip(
                    label: status,
                    selected: provider.statusFilter == status,
                    onTap: () => provider.setStatusFilter(status),
                  ),
                ),
              ),

              // Divider + tech filters (only when technologies exist)
              if (technologies.isNotEmpty) ...[
                const SizedBox(width: 4),
                const VerticalDivider(width: 1, indent: 6, endIndent: 6),
                const SizedBox(width: 10),
                // 'All' tech chip
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: TechChip(
                    label: 'All',
                    selected: provider.technologyFilter == 'All',
                    onTap: () => provider.setTechnologyFilter('All'),
                  ),
                ),
                ...technologies.map(
                  (tech) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: TechChip(
                      label: tech,
                      selected: provider.technologyFilter == tech,
                      onTap: () => provider.setTechnologyFilter(tech),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
