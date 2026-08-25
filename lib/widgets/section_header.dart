import 'package:flutter/material.dart';

/// A row widget that displays a section title on the left and an optional
/// action link (e.g. "View All") on the right.
class SectionHeader extends StatelessWidget {
  final String title;

  /// Label for the trailing action button. When null, no button is shown.
  final String? actionLabel;

  /// Callback for the trailing action button.
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
            fontWeight: FontWeight.w700,
            color: scheme.onSurface,
          ),
        ),
        if (actionLabel != null && onAction != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              foregroundColor: scheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              visualDensity: VisualDensity.compact,
            ),
            child: Text(
              actionLabel!,
              style: textTheme.labelMedium?.copyWith(
                color: scheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
