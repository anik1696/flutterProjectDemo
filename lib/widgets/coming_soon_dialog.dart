import 'package:flutter/material.dart';

/// A dialog that informs the user that a feature is not yet available.
///
/// Usage:
/// ```dart
/// ComingSoonDialog.show(context, featureName: 'AI Resume Builder');
/// ```
class ComingSoonDialog extends StatelessWidget {
  final String? featureName;

  const ComingSoonDialog({super.key, this.featureName});

  /// Convenience helper to show the dialog without boilerplate at the call site.
  static void show(BuildContext context, {String? featureName}) {
    showDialog(
      context: context,
      builder: (_) => ComingSoonDialog(featureName: featureName),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final String contentText = featureName != null
        ? '$featureName is coming soon.'
        : 'This feature is coming soon.';

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      icon: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: scheme.primaryContainer,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.rocket_launch_rounded,
          size: 36,
          color: scheme.onPrimaryContainer,
        ),
      ),
      title: Text(
        'Coming Soon',
        style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        textAlign: TextAlign.center,
      ),
      content: Text(
        contentText,
        style: textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
