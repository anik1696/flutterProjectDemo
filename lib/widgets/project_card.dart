import 'package:flutter/material.dart';
import '../models/project.dart';
import '../utils/constants.dart';
import '../app/theme.dart';
import 'status_badge.dart';
import 'tech_chip.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback? onTap;

  const ProjectCard({super.key, required this.project, this.onTap});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap ?? () => Navigator.pushNamed(context, kRouteProjectDetails, arguments: project),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project.title,
                            style: tt.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textDark,
                            ),
                          ),
                          if (project.category.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              project.category,
                              style: tt.labelMedium?.copyWith(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    StatusBadge(status: project.status, compact: true),
                  ],
                ),
                
                if (project.description.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    project.description,
                    style: tt.bodyMedium?.copyWith(
                      color: AppTheme.textLight,
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

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
      ),
    );
  }
}
