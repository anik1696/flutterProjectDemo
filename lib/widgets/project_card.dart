import 'package:flutter/material.dart';
import '../models/project.dart';
import '../utils/constants.dart';
import 'status_badge.dart';
import 'tech_chip.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback? onTap;

  const ProjectCard({super.key, required this.project, this.onTap});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Card(
      child: InkWell(
        onTap: onTap ??
            () => Navigator.pushNamed(context, kRouteProjectDetails, arguments: project),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ───────────────────────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      project.title,
                      style: tt.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  StatusBadge(status: project.status, compact: true),
                ],
              ),
              
              if (project.category.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  project.category,
                  style: tt.bodySmall?.copyWith(color: cs.primary),
                ),
              ],

              // ── Description ───────────────────────────────────────────────
              if (project.description.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  project.description,
                  style: tt.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              // ── Tech chips ────────────────────────────────────────────────
              if (project.technologies.isNotEmpty) ...[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: project.technologies.take(4).map((t) => TechChip(label: t)).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
