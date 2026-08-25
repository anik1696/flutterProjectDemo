import 'package:flutter/material.dart';
import '../models/project.dart';
import '../utils/constants.dart';
import 'status_badge.dart';
import 'tech_chip.dart';

/// A card that summarises a [Project] with its title, description,
/// status badge, category and technology chips.
/// Tapping the card navigates to the project details screen.
class ProjectCard extends StatelessWidget {
  final Project project;
  /// Override the default tap navigation if needed.
  final VoidCallback? onTap;

  const ProjectCard({super.key, required this.project, this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return Card(
      child: InkWell(
        onTap: onTap ??
            () => Navigator.pushNamed(
                  context,
                  kRouteProjectDetails,
                  arguments: project,
                ),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title + badge row
              Row(
                children: [
                  Expanded(
                    child: Text(
                      project.title,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  StatusBadge(status: project.status, compact: true),
                ],
              ),

              if (project.description.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  project.description,
                  style: textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              if (project.category.isNotEmpty) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.label_outline_rounded,
                      size: 14,
                      color: scheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      project.category,
                      style: textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],

              if (project.technologies.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    ...project.technologies
                        .take(4)
                        .map((t) => TechChip(label: t)),
                    if (project.technologies.length > 4)
                      TechChip(
                        label: '+${project.technologies.length - 4} more',
                      ),
                  ],
                ),
              ],

              // GitHub / Live Demo indicators
              if (project.githubUrl.isNotEmpty ||
                  project.liveDemoUrl.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (project.githubUrl.isNotEmpty) ...[
                      Icon(Icons.code_rounded,
                          size: 14, color: scheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        'GitHub',
                        style: textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (project.githubUrl.isNotEmpty &&
                        project.liveDemoUrl.isNotEmpty)
                      const SizedBox(width: 12),
                    if (project.liveDemoUrl.isNotEmpty) ...[
                      Icon(Icons.open_in_new_rounded,
                          size: 14, color: scheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        'Live Demo',
                        style: textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
