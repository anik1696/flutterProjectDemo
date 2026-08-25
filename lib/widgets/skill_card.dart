import 'package:flutter/material.dart';
import '../models/skill.dart';
import '../app/theme.dart';

/// A card that visualises a [Skill] with a proficiency bar, experience info,
/// and optional edit / delete actions via a popup menu.
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
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final Color profColor =
        AppTheme.proficiencyColor(skill.proficiency, scheme);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header row ──────────────────────────────────────────────
            Row(
              children: [
                // Coloured avatar with first letter of skill name.
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: profColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    skill.name.isNotEmpty ? skill.name[0].toUpperCase() : '?',
                    style: textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Skill name + category.
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        skill.name,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        skill.category,
                        style: textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Popup menu for edit / delete.
                PopupMenuButton<_SkillAction>(
                  icon: const Icon(Icons.more_vert_rounded),
                  onSelected: (action) {
                    switch (action) {
                      case _SkillAction.edit:
                        onEdit?.call();
                      case _SkillAction.delete:
                        onDelete?.call();
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: _SkillAction.edit,
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 18),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: _SkillAction.delete,
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline_rounded, size: 18),
                          SizedBox(width: 8),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            // ── Proficiency label + percentage ─────────────────────────
            Row(
              children: [
                Text(
                  skill.proficiency,
                  style: textTheme.bodySmall?.copyWith(
                    color: profColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '${(skill.proficiencyPercentage * 100).round()}%',
                  style: textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // ── Progress bar ────────────────────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: skill.proficiencyPercentage,
                color: profColor,
                backgroundColor: profColor.withOpacity(0.15),
                minHeight: 6,
              ),
            ),

            // ── Years of experience ─────────────────────────────────────
            if (skill.yearsExperience > 0) ...[
              const SizedBox(height: 6),
              Text(
                '${skill.yearsExperience.toStringAsFixed(1)} yrs experience',
                style: textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],

            // ── Notes ───────────────────────────────────────────────────
            if (skill.notes != null && skill.notes!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                skill.notes!,
                style: textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Internal enum for popup menu actions — not part of the public API.
enum _SkillAction { edit, delete }
