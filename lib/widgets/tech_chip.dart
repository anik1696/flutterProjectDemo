import 'package:flutter/material.dart';

class TechChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final bool showClose;
  final VoidCallback? onClose;

  const TechChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.showClose = false,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = cs.brightness == Brightness.dark;

    if (onTap != null) {
      return FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap!(),
        labelStyle: TextStyle(
          fontSize: 11,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? cs.primary : cs.onSurfaceVariant,
        ),
        backgroundColor: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : cs.surfaceContainerHighest,
        selectedColor: cs.primary.withValues(alpha: 0.12),
        side: BorderSide(
          color: selected
              ? cs.primary.withValues(alpha: 0.4)
              : cs.outline.withValues(alpha: 0.2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: selected
            ? cs.primary.withValues(alpha: 0.12)
            : isDark
                ? Colors.white.withValues(alpha: 0.06)
                : cs.surfaceContainerHighest,
        border: Border.all(
          color: selected
              ? cs.primary.withValues(alpha: 0.3)
              : isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : cs.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: selected ? cs.primary : cs.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (showClose && onClose != null) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onClose,
              child: Icon(Icons.close_rounded,
                  size: 12, color: cs.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}
