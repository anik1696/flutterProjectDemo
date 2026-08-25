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
    final isDark = cs.brightness == Brightness.dark;
    final profColor = AppTheme.proficiencyColor(skill.proficiency, cs);
    final pct = skill.proficiencyPercentage;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark ? const Color(0xFF16213E) : cs.surface,
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.07)
              : cs.outline.withValues(alpha: 0.1),
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          // ── Left colored bar ──────────────────────────────────────────────
          Container(
            width: 4,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: LinearGradient(
                colors: [profColor, profColor.withValues(alpha: 0.3)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // ── Content ───────────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        skill.name,
                        style: tt.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Proficiency pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: profColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        skill.proficiency,
                        style: tt.labelSmall?.copyWith(
                          color: profColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      skill.category,
                      style: tt.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                    if (skill.yearsExperience > 0) ...[
                      Text(
                        ' · ',
                        style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                      ),
                      Text(
                        '${skill.yearsExperience.toStringAsFixed(1)} yrs',
                        style: tt.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                // ── Progress bar ──────────────────────────────────────────
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: pct,
                    minHeight: 6,
                    backgroundColor: profColor.withValues(alpha: 0.12),
                    color: profColor,
                  ),
                ),
              ],
            ),
          ),

          // ── Actions menu ──────────────────────────────────────────────────
          if (onEdit != null || onDelete != null)
            PopupMenuButton<_SkillAction>(
              icon: Icon(Icons.more_vert_rounded,
                  size: 18, color: cs.onSurfaceVariant),
              onSelected: (action) {
                switch (action) {
                  case _SkillAction.edit:
                    onEdit?.call();
                  case _SkillAction.delete:
                    onDelete?.call();
                }
              },
              itemBuilder: (ctx) => const [
                PopupMenuItem(
                  value: _SkillAction.edit,
                  child: Row(children: [
                    Icon(Icons.edit_outlined, size: 16),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ]),
                ),
                PopupMenuItem(
                  value: _SkillAction.delete,
                  child: Row(children: [
                    Icon(Icons.delete_outline_rounded, size: 16),
                    SizedBox(width: 8),
                    Text('Delete'),
                  ]),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

enum _SkillAction { edit, delete }
