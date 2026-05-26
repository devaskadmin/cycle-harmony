import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../screens/fertility/fertility_screen.dart';
import '../../screens/symptoms/symptoms_screen.dart';
import '../../widgets/cards/dashboard_action_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    required this.onSelectBottomTab,
    super.key,
  });

  final ValueChanged<int> onSelectBottomTab;

  @override
  Widget build(BuildContext context) {
    final cards = <_DashboardItem>[
      _DashboardItem(
        title: 'Track Period',
        icon: Icons.water_drop,
        colors: const [Color(0xFFF45B95), AppColors.trackPeriod],
        onTap: () => onSelectBottomTab(1),
      ),
      _DashboardItem(
        title: 'Cycle Calendar',
        icon: Icons.calendar_month,
        colors: const [Color(0xFF9D5BE6), AppColors.calendar],
        onTap: () => onSelectBottomTab(2),
      ),
      _DashboardItem(
        title: 'Mood & Symptoms',
        icon: Icons.sentiment_satisfied_alt,
        colors: const [Color(0xFF62B1F6), AppColors.mood],
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const SymptomsScreen()),
        ),
      ),
      _DashboardItem(
        title: 'Fertility Plan',
        icon: Icons.favorite,
        colors: const [Color(0xFF68C97A), AppColors.fertility],
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const FertilityScreen()),
        ),
      ),
      _DashboardItem(
        title: 'AI Health Insights',
        icon: Icons.lightbulb,
        colors: const [Color(0xFFF8BB55), AppColors.ai],
        onTap: () =>
            _showPlaceholder(context, 'AI Health Insights is coming in v0.02'),
      ),
      _DashboardItem(
        title: 'Health Analyzer',
        icon: Icons.analytics,
        colors: const [Color(0xFFBCAAA4), Color(0xFF8D6E63)],
        onTap: () => _showPlaceholder(
            context, 'Health Analyzer is a local placeholder for v0.01'),
      ),
      _DashboardItem(
        title: 'Cycle Forecast',
        icon: Icons.track_changes,
        colors: const [Color(0xFF42C8D5), AppColors.forecast],
        onTap: () => onSelectBottomTab(1),
      ),
      _DashboardItem(
        title: 'Log Symptoms',
        icon: Icons.healing,
        colors: const [Color(0xFFF27474), AppColors.symptoms],
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const SymptomsScreen()),
        ),
      ),
      _DashboardItem(
        title: 'My Reminders',
        icon: Icons.notifications,
        colors: const [Color(0xFF9D72DE), Color(0xFF7D56C8)],
        onTap: () => onSelectBottomTab(3),
      ),
      _DashboardItem(
        title: 'AI Chat Assistant',
        icon: Icons.chat_bubble,
        colors: const [Color(0xFF31C2B7), AppColors.forecast],
        onTap: () =>
            _showPlaceholder(context, 'AI Chat Assistant is disabled in v0.01'),
      ),
    ];

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          pinned: true,
          expandedHeight: 118,
          backgroundColor: AppColors.primary,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            title: Text(
              'CycleAI Dashboard',
              style:
                  TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.14,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            delegate: SliverChildBuilderDelegate(
              childCount: cards.length,
              (context, index) {
                final item = cards[index];
                return DashboardActionCard(
                  title: item.title,
                  icon: item.icon,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: item.colors,
                  ),
                  onTap: item.onTap,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showPlaceholder(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _DashboardItem {
  const _DashboardItem({
    required this.title,
    required this.icon,
    required this.colors,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback onTap;
}
