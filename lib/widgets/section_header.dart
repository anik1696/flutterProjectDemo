import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: scheme.onSurface,
            letterSpacing: -0.3,
          ),
        ),
        if (actionLabel != null && onAction != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              foregroundColor: scheme.onSurfaceVariant,
              padding: const EdgeInsets.symmetric(horizontal: 0),
              visualDensity: VisualDensity.compact,
            ),
            child: Text(
              actionLabel!,
              style: textTheme.labelMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
