import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class CycleHubScreen extends StatelessWidget {
  const CycleHubScreen({
    required this.onOpenTracker,
    required this.onOpenCalendar,
    required this.onOpenReminders,
    required this.onOpenCheckIn,
    super.key,
  });

  final VoidCallback onOpenTracker;
  final VoidCallback onOpenCalendar;
  final VoidCallback onOpenReminders;
  final VoidCallback onOpenCheckIn;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          pinned: true,
          expandedHeight: 104,
          backgroundColor: AppColors.primary,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            title: Text(
              'Cycle',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                _HubActionCard(
                  title: 'Open Tracker',
                  subtitle: 'Cycle progress, next period, and predictions',
                  icon: Icons.water_drop,
                  onTap: onOpenTracker,
                ),
                _HubActionCard(
                  title: 'Open Calendar',
                  subtitle: 'View phase and notes by day',
                  icon: Icons.calendar_month,
                  onTap: onOpenCalendar,
                ),
                _HubActionCard(
                  title: 'Open Reminders',
                  subtitle: 'Manage your cycle notifications',
                  icon: Icons.notifications_active,
                  onTap: onOpenReminders,
                ),
                _HubActionCard(
                  title: 'Open Daily Check-In',
                  subtitle: 'Mood and symptom logging',
                  icon: Icons.healing,
                  onTap: onOpenCheckIn,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HubActionCard extends StatelessWidget {
  const _HubActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
