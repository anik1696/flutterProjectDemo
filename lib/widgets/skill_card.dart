import 'package:flutter/material.dart';
import '../models/skill.dart';
import '../app/theme.dart';

class SkillCard extends StatelessWidget {
  final Skill skill;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const SkillCard({
    super.key,
    required this.skill,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        skill.name,
                        style: tt.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${skill.category} • ${skill.yearsExperience.toStringAsFixed(1)} yrs',
                        style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    skill.proficiency,
                    style: tt.labelSmall?.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (onEdit != null || onDelete != null) ...[
                  const SizedBox(width: 8),
                  PopupMenuButton<_SkillAction>(
                    icon: Icon(Icons.more_horiz, size: 20, color: cs.onSurfaceVariant),
                    onSelected: (action) {
                      if (action == _SkillAction.edit) onEdit?.call();
                      if (action == _SkillAction.delete) onDelete?.call();
                    },
                    itemBuilder: (ctx) => const [
                      PopupMenuItem(value: _SkillAction.edit, child: Text('Edit')),
                      PopupMenuItem(value: _SkillAction.delete, child: Text('Delete')),
                    ],
                  ),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum _SkillAction { edit, delete }
