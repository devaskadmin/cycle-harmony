import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class ReminderTileCard extends StatelessWidget {
  const ReminderTileCard({
    required this.title,
    required this.description,
    required this.time,
    required this.enabled,
    required this.onChanged,
    required this.index,
    super.key,
  });

  final String title;
  final String description;
  final String time;
  final bool enabled;
  final ValueChanged<bool> onChanged;
  final int index;

  Color get accent {
    switch (index % 3) {
      case 0:
        return AppColors.trackPeriod;
      case 1:
        return AppColors.fertility;
      default:
        return AppColors.ai;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28,
              height: 28,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.alarm, size: 16, color: accent),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'At $time',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),
            Switch(value: enabled, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}
