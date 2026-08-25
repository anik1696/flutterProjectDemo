import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../providers/project_provider.dart';
import '../models/project.dart';
import '../utils/constants.dart';
import '../widgets/status_badge.dart';
import '../widgets/tech_chip.dart';

/// Detailed read-only view for a single [Project].
class ProjectDetailsScreen extends StatefulWidget {
  final Project project;

  const ProjectDetailsScreen({super.key, required this.project});

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  // Keep a local reference that stays fresh after edits
  late Project _project;

  @override
  void initState() {
    super.initState();
    _project = widget.project;
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open URL')),
          );
        }
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid URL')),
        );
      }
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Project?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await context.read<ProjectProvider>().deleteProject(_project.id);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project deleted successfully.')),
        );
      }
    }
  }

  Widget _buildSection(String label, String content) {
    if (content.isEmpty) return const SizedBox.shrink();
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          label,
          style: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: scheme.primary,
          ),
        ),
        const SizedBox(height: 6),
        Text(content, style: textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: scheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('MMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _project.title,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit',
            onPressed: () async {
              await Navigator.pushNamed(
                context,
                kRouteEditProject,
                arguments: _project,
              );
              // Refresh from provider after edit
              if (mounted) {
                final updated = context
                    .read<ProjectProvider>()
                    .getProjectById(_project.id);
                if (updated != null) setState(() => _project = updated);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.delete_outline_rounded, color: scheme.error),
            tooltip: 'Delete',
            onPressed: _confirmDelete,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + Status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    _project.title,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                StatusBadge(status: _project.status),
              ],
            ),

            // Category
            if (_project.category.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.category_outlined,
                      size: 14, color: scheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    _project.category,
                    style: textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],

            // Description
            _buildSection('Description', _project.description),

            // Tech Stack
            if (_project.technologies.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                'Tech Stack',
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: scheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _project.technologies
                    .map((t) => TechChip(label: t))
                    .toList(),
              ),
            ],

            // Dates
            if (_project.startDate != null || _project.targetDate != null) ...[
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (_project.startDate != null)
                    _buildInfoChip(
                      Icons.play_arrow_rounded,
                      'Started: ${_formatDate(_project.startDate)}',
                    ),
                  if (_project.targetDate != null)
                    _buildInfoChip(
                      Icons.flag_rounded,
                      'Target: ${_formatDate(_project.targetDate)}',
                    ),
                ],
              ),
            ],

            // Extra sections
            _buildSection('Milestone', _project.milestone),
            _buildSection('Architecture Notes', _project.architectureNotes),
            _buildSection('Feature Notes', _project.featureNotes),

            // Links
            if (_project.githubUrl.isNotEmpty ||
                _project.liveDemoUrl.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                'Links',
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: scheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  if (_project.githubUrl.isNotEmpty)
                    OutlinedButton.icon(
                      onPressed: () => _launchUrl(_project.githubUrl),
                      icon: const Icon(Icons.code_rounded),
                      label: const Text('View on GitHub'),
                    ),
                  if (_project.liveDemoUrl.isNotEmpty)
                    FilledButton.icon(
                      onPressed: () => _launchUrl(_project.liveDemoUrl),
                      icon: const Icon(Icons.open_in_new_rounded),
                      label: const Text('Live Demo'),
                    ),
                ],
              ),
            ],

            const SizedBox(height: 32),

            // Created at footer
            Text(
              'Added ${_formatDate(_project.createdAt)}',
              style: textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
