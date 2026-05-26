import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/reminder_provider.dart';
import '../../widgets/cards/reminder_tile_card.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReminderProvider>(
      builder: (context, reminders, _) {
        return CustomScrollView(
          slivers: [
            const SliverAppBar(
              pinned: true,
              expandedHeight: 102,
              backgroundColor: AppColors.primary,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                title: Text('Cycle Reminders',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList.builder(
                itemCount: reminders.reminders.length,
                itemBuilder: (context, index) {
                  final item = reminders.reminders[index];
                  return ReminderTileCard(
                    index: index,
                    title: item.title,
                    description: item.description,
                    time: item.time,
                    enabled: item.enabled,
                    onChanged: (enabled) {
                      reminders.toggleReminder(index, enabled);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
