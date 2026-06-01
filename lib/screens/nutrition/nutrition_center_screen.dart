import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/cycle_guidance.dart';
import '../../providers/cycle_provider.dart';

class NutritionCenterScreen extends StatelessWidget {
  const NutritionCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CycleProvider>(
      builder: (context, cycle, _) {
        final now = DateTime.now();
        final phase = _phaseLabel(cycle, now);
        final nutrition = CycleGuidance.nutritionByPhase[phase] ??
            CycleGuidance.nutritionByPhase['Follicular']!;

        return CustomScrollView(
          slivers: [
            const SliverAppBar(
              pinned: true,
              expandedHeight: 104,
              backgroundColor: AppColors.primary,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                title: Text(
                  'Nutrition Center',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionCard(
                      title: "Today's Nutrition Blueprint",
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Current phase: $phase'),
                          const SizedBox(height: 8),
                          ...nutrition.map((item) => Text('• $item')),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const _SectionCard(
                      title: 'Key Vitamins and Minerals',
                      child: Text(
                          'Phase-prioritized micronutrients are coming in v1.1.'),
                    ),
                    const SizedBox(height: 12),
                    const _SectionCard(
                      title: 'Foods to Prioritize',
                      child: Text(
                          'Food-group recommendations are scaffolded for v1.1.'),
                    ),
                    const SizedBox(height: 12),
                    const _SectionCard(
                      title: 'Foods to Limit',
                      child: Text(
                          'Phase-based moderation guidance is scaffolded for v1.1.'),
                    ),
                    const SizedBox(height: 12),
                    const _SectionCard(
                      title: 'Daily Sample Meal Plan',
                      child:
                          Text('Meal plan templates are scaffolded for v1.1.'),
                    ),
                    const SizedBox(height: 12),
                    const _SectionCard(
                      title: 'Recipe of the Day',
                      child: Text(
                          'Recipe recommendations are scaffolded for v1.1.'),
                    ),
                    const SizedBox(height: 12),
                    const _SectionCard(
                      title: 'Phase-Specific Nutrition Education',
                      child: Text(
                          'Educational content modules are scaffolded for v1.1.'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}
