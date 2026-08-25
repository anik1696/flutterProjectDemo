import 'package:flutter/material.dart';
import '../models/project.dart';
import '../utils/constants.dart';
import '../app/theme.dart';
import 'tech_chip.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback? onTap;

  const ProjectCard({super.key, required this.project, this.onTap});

  IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'freelance': return Icons.work_rounded;
      case 'open source': return Icons.public_rounded;
      case 'personal': return Icons.person_rounded;
      default: return Icons.folder_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final iconColor = AppTheme.categoryIconColor(project.category);
    final iconBg = AppTheme.categoryIconBg(project.category);

    return Container(
      decoration: AppTheme.cardDecoration,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap ?? () => Navigator.pushNamed(context, kRouteProjectDetails, arguments: project),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon circle
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                  child: Icon(_categoryIcon(project.category), color: iconColor, size: 22),
                ),
                const SizedBox(width: 14),
                // Content
                Expanded(
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
                                  style: tt.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  project.category.isNotEmpty ? project.category : 'Project',
                                  style: tt.bodySmall?.copyWith(color: AppTheme.textSecond),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Status Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.statusBg(project.status),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              project.status,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.statusColor(project.status),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (project.description.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          project.description,
                          style: tt.bodySmall?.copyWith(
                            color: AppTheme.textSecond,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (project.technologies.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: project.technologies.take(4).map((t) => TechChip(label: t)).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
