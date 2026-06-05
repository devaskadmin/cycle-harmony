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
                return _DashboardHeroCard(
                  cycle: cycle,
                  onOpenNutrition: () => onSelectBottomTab(1),
                );
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
  const _DashboardHeroCard({
    required this.cycle,
    required this.onOpenNutrition,
  });

  final CycleProvider cycle;
  final VoidCallback onOpenNutrition;

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
    final profile = CycleGuidance.profileForPhase(phase);
    final presentation = _presentationFor(phase);
    final nutrientNames = profile.priorityNutrients
        .take(4)
        .map((guidance) => guidance.name)
        .toList();

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
                fontSize: 23,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              '$phase Phase',
              style: const TextStyle(
                color: Color(0xFFE9DBFF),
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              presentation.theme,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 28,
                height: 1.05,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _HeroStatPill(
                    label: 'Cycle Day',
                    value: '$cycleDay of $cycleLength',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _HeroStatPill(
                    label: 'Next Period',
                    value: DateFormat.MMMMd().format(nextPeriod),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              presentation.coachingSummary,
              style: const TextStyle(
                color: Colors.white,
                height: 1.4,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 18),
            const _HeroSectionLabel(
              icon: Icons.auto_awesome,
              label: 'Priority Nutrients',
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: nutrientNames
                  .map(
                    (name) => _NutrientChip(label: name),
                  )
                  .toList(),
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              decoration: BoxDecoration(
                color: const Color(0x20FFFFFF),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0x55FFFFFF)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _HeroSectionLabel(
                    icon: Icons.directions_run,
                    label: "Today's Activity Focus",
                  ),
                  const SizedBox(height: 8),
                  Text(
                    presentation.activitySummary,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: onOpenNutrition,
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'View Full Nutrition Blueprint',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
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

  _PhasePresentation _presentationFor(String phase) {
    switch (phase) {
      case 'Menstrual':
        return const _PhasePresentation(
          theme: 'Recovery & Replenishment',
          coachingSummary:
              'Restore energy with gentle nourishment, hydration, and lighter movement.',
          activitySummary: 'Recovery, walking, mobility, yoga',
        );
      case 'Follicular':
        return const _PhasePresentation(
          theme: 'Build & Prepare',
          coachingSummary:
              'Use rising energy to support balanced meals, productive training, and forward momentum.',
          activitySummary: 'Strength, intervals, skills, mobility',
        );
      case 'Ovulatory':
        return const _PhasePresentation(
          theme: 'Peak Performance',
          coachingSummary:
              'Lean into your highest-output window with strong meals, hydration, and confident movement.',
          activitySummary: 'Power, intervals, classes, mobility',
        );
      case 'Luteal':
      default:
        return const _PhasePresentation(
          theme: 'Stability & Recovery',
          coachingSummary:
              'Keep meals structured and movement steady to support energy, appetite, and recovery.',
          activitySummary: 'Strength, walking, mobility, recovery',
        );
    }
  }
}

class _HeroStatPill extends StatelessWidget {
  const _HeroStatPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0x18FFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x45FFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFEADFFF),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSectionLabel extends StatelessWidget {
  const _HeroSectionLabel({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFEFE4FF), size: 16),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFEFE4FF),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _NutrientChip extends StatelessWidget {
  const _NutrientChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _PhasePresentation {
  const _PhasePresentation({
    required this.theme,
    required this.coachingSummary,
    required this.activitySummary,
  });

  final String theme;
  final String coachingSummary;
  final String activitySummary;
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
