import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/cycle_guidance.dart';
import '../../providers/cycle_provider.dart';
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
        title: 'Nutrition Center',
        icon: Icons.restaurant_menu,
        colors: const [Color(0xFF8C60E8), AppColors.calendar],
        onTap: () => onSelectBottomTab(1),
      ),
      _DashboardItem(
        title: 'Nutrient Priorities',
        icon: Icons.science_outlined,
        colors: const [Color(0xFF7E4ED7), AppColors.primary],
        onTap: () => onSelectBottomTab(1),
      ),
      _DashboardItem(
        title: 'Meal Plan',
        icon: Icons.breakfast_dining,
        colors: const [Color(0xFF6E46C8), Color(0xFF8B63E4)],
        onTap: () => onSelectBottomTab(1),
      ),
      _DashboardItem(
        title: 'Recipe of the Day',
        icon: Icons.menu_book,
        colors: const [Color(0xFF7D57D2), Color(0xFFA071E8)],
        onTap: () => onSelectBottomTab(2),
      ),
      _DashboardItem(
        title: 'Log Period Start',
        icon: Icons.water_drop_outlined,
        colors: const [Color(0xFFF45B95), AppColors.trackPeriod],
        onTap: () => _logPeriodStart(context),
      ),
      _DashboardItem(
        title: 'Daily Check-In',
        icon: Icons.sentiment_satisfied_alt,
        colors: const [Color(0xFF62B1F6), AppColors.mood],
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const SymptomsScreen()),
        ),
      ),
      _DashboardItem(
        title: 'Phase Timeline',
        icon: Icons.timeline,
        colors: const [Color(0xFF42C8D5), AppColors.forecast],
        onTap: () => onSelectBottomTab(3),
      ),
      _DashboardItem(
        title: 'Cycle Calendar',
        icon: Icons.calendar_month,
        colors: const [Color(0xFF9D5BE6), AppColors.calendar],
        onTap: () => onSelectBottomTab(3),
      ),
      _DashboardItem(
        title: 'My Reminders',
        icon: Icons.notifications_active,
        colors: const [Color(0xFF9D72DE), Color(0xFF7D56C8)],
        onTap: () => onSelectBottomTab(3),
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
              'Cycle Harmony Dashboard',
              style:
                  TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          sliver: SliverToBoxAdapter(
            child: Consumer<CycleProvider>(
              builder: (context, cycle, _) {
                return _DashboardHeroCard(cycle: cycle);
              },
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
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

  Future<void> _logPeriodStart(BuildContext context) async {
    final cycle = context.read<CycleProvider>();
    await cycle.logPeriodStart(DateTime.now());
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Period start logged for today.')),
    );
  }
}

class _DashboardHeroCard extends StatelessWidget {
  const _DashboardHeroCard({required this.cycle});

  final CycleProvider cycle;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final greeting = _timeGreeting(now);
    final firstName = cycle.firstName;
    final displayName = firstName.isEmpty ? 'there' : firstName;

    if (!cycle.hasCycleSetup) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6D3FBD), AppColors.primary],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$greeting, $displayName',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Set up your cycle to unlock your daily phase, nutrition, and activity guidance.',
                style: TextStyle(
                  color: Colors.white,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final cycleDay = cycle.cycleDayFor(now);
    final cycleLength =
        cycle.currentCycle?.cycleLength ?? cycle.defaultCycleLength;
    final nextPeriod = cycle.nextPeriodDate();
    final phase = _phaseLabel(cycle, now);

    final nutrition = CycleGuidance.nutritionByPhase[phase] ??
        CycleGuidance.nutritionByPhase['Follicular']!;
    final activity = CycleGuidance.activityByPhase[phase] ??
        CycleGuidance.activityByPhase['Follicular']!;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6D3FBD), AppColors.primary],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x336D3FBD),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$greeting, $displayName',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You are currently in your $phase Phase',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Day $cycleDay of $cycleLength',
              style: const TextStyle(
                color: Color(0xFFE5D9FF),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Next period predicted: ${DateFormat.MMMMd().format(nextPeriod)}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0x14FFFFFF),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0x50FFFFFF)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final sideBySide = constraints.maxWidth >= 760;

                    final nutritionCard = Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFD9C6FF)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.restaurant_menu,
                                  color: AppColors.primary,
                                  size: 18,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  "Today's Nutrition Focus",
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ...nutrition.map(
                              (item) => Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text(
                                  '• $item',
                                  style: const TextStyle(
                                    color: Color(0xFF2F2348),
                                    fontWeight: FontWeight.w600,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );

                    final activityCard = Container(
                      decoration: BoxDecoration(
                        color: const Color(0x20FFFFFF),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0x66FFFFFF)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.directions_run,
                                  color: Color(0xFFEFE6FF),
                                  size: 18,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  "Today's Activity Focus",
                                  style: TextStyle(
                                    color: Color(0xFFEFE6FF),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              activity,
                              style: const TextStyle(
                                color: Colors.white,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );

                    if (sideBySide) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 2, child: nutritionCard),
                          const SizedBox(width: 10),
                          Expanded(child: activityCard),
                        ],
                      );
                    }

                    return Column(
                      children: [
                        nutritionCard,
                        const SizedBox(height: 10),
                        activityCard,
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _timeGreeting(DateTime now) {
    final hour = now.hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 18) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  String _phaseLabel(CycleProvider cycle, DateTime date) {
    final phase = cycle.phaseForDate(date);
    if (phase == 'Period') {
      return 'Menstrual';
    }
    if (phase == 'Ovulation') {
      return 'Ovulatory';
    }
    if (phase == 'Fertile') {
      return 'Follicular';
    }

    final cycleDay = cycle.cycleDayFor(date);
    final cycleLength =
        cycle.currentCycle?.cycleLength ?? cycle.defaultCycleLength;
    final ovulationDay = (cycleLength - 14).clamp(1, cycleLength);
    if (cycleDay < ovulationDay) {
      return 'Follicular';
    }
    return 'Luteal';
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
