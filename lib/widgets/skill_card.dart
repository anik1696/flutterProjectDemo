import 'package:flutter/material.dart';
import '../models/skill.dart';
import '../app/theme.dart';

class SkillCard extends StatelessWidget {
  final Skill skill;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const SkillCard({super.key, required this.skill, this.onEdit, this.onDelete});

  IconData _skillIcon(String category) {
    switch (category.toLowerCase()) {
      case 'framework': return Icons.widgets_rounded;
      case 'programming language': return Icons.code_rounded;
      case 'backend': return Icons.dns_rounded;
      case 'database': return Icons.storage_rounded;
      case 'cloud & devops': return Icons.cloud_rounded;
      case 'tool': return Icons.build_rounded;
      default: return Icons.psychology_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final iconColor = AppTheme.categoryIconColor(skill.category);
    final iconBg = AppTheme.categoryIconBg(skill.category);
    final profColor = AppTheme.proficiencyColor(skill.proficiency);
    final profBg = AppTheme.proficiencyBg(skill.proficiency);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onLongPress: (onEdit != null || onDelete != null)
            ? () => _showOptions(context)
            : null,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Colored icon circle
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                child: Icon(_skillIcon(skill.category), color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      skill.name,
                      style: tt.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${skill.category} • ${skill.yearsExperience.toStringAsFixed(1)} yrs',
                      style: tt.bodySmall?.copyWith(color: AppTheme.textSecond),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Proficiency pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: profBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  skill.proficiency,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: profColor,
                  ),
                ),
              ),
              if (onEdit != null || onDelete != null) ...[
                const SizedBox(width: 4),
                PopupMenuButton<_Action>(
                  icon: Icon(Icons.more_horiz, size: 20, color: AppTheme.textSecond),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onSelected: (action) {
                    if (action == _Action.edit) onEdit?.call();
                    if (action == _Action.delete) onDelete?.call();
                  },
                  itemBuilder: (ctx) => const [
                    PopupMenuItem(value: _Action.edit, child: Text('Edit')),
                    PopupMenuItem(value: _Action.delete, child: Text('Delete', style: TextStyle(color: AppTheme.danger))),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onEdit != null)
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Edit'),
                onTap: () { Navigator.pop(context); onEdit?.call(); },
              ),
            if (onDelete != null)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: AppTheme.danger),
                title: const Text('Delete', style: TextStyle(color: AppTheme.danger)),
                onTap: () { Navigator.pop(context); onDelete?.call(); },
              ),
          ],
        ),
      ),
    );
  }
}

enum _Action { edit, delete }
