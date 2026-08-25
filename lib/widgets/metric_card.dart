import 'package:flutter/material.dart';

/// A metric/stat card for the dashboard showing a label, value, and icon.
class MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final color = iconColor ?? scheme.primary;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
