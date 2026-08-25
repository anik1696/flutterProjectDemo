import 'package:flutter/material.dart';
import '../app/theme.dart';

/// A badge showing project status with color coding.
class StatusBadge extends StatelessWidget {
  final String status;
  final bool compact;

  const StatusBadge({
    super.key,
    required this.status,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = AppTheme.statusColor(status, scheme);
    final bgColor = AppTheme.statusBackgroundColor(status, scheme);
    final icon = _statusIcon(status);

    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          status,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'Completed':
        return Icons.check_circle_rounded;
      case 'In Progress':
        return Icons.timelapse_rounded;
      case 'Archived':
        return Icons.archive_rounded;
      default:
        return Icons.circle_outlined;
    }
  }
}
