import 'package:flutter/material.dart';

/// Displays a technology name as a small chip.
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
    final scheme = Theme.of(context).colorScheme;

    if (onTap != null) {
      return FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap!(),
        labelStyle: TextStyle(
          fontSize: 12,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4),
      );
    }

    return Chip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor:
          selected ? scheme.primary : scheme.surfaceContainerHighest,
      side: BorderSide(color: scheme.outline.withOpacity(0.2)),
      padding: const EdgeInsets.symmetric(horizontal: 2),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onDeleted: showClose ? onClose : null,
      deleteIcon: showClose
          ? Icon(Icons.close_rounded, size: 14, color: scheme.onSurfaceVariant)
          : null,
    );
  }
}
