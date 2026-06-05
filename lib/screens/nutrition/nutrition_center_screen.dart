import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/cycle_guidance.dart';
import '../../core/models/phase_profile.dart';
import '../../providers/cycle_provider.dart';

class NutritionCenterScreen extends StatelessWidget {
  const NutritionCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CycleProvider>(
      builder: (context, cycle, _) {
        final now = DateTime.now();
        final phase = _phaseLabel(cycle, now);
        final profile = CycleGuidance.profileForPhase(phase);

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
                    _OverviewCard(
                      phase: phase,
                      description: profile.phaseDescription,
                    ),
                    const SizedBox(height: 18),
                    _SectionCard(
                      title: 'Hormone Trends',
                      icon: Icons.monitor_heart_outlined,
                      child: Column(
                        children: profile.hormoneTrends
                            .map((trend) => _HormoneRow(trend: trend))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _SectionCard(
                      title: 'Key Vitamins and Minerals',
                      icon: Icons.auto_awesome,
                      child: Column(
                        children: profile.priorityNutrients
                            .map((item) => _NutrientRow(item: item))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _SectionCard(
                      title: profile.foodsToPrioritize.title,
                      icon: Icons.shopping_basket_outlined,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _FoodChipWrap(items: profile.foodsToPrioritize.items),
                          const SizedBox(height: 12),
                          Text(
                            profile.foodsToPrioritize.rationale,
                            style: const TextStyle(
                              color: Color(0xFF5A5566),
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    _SectionCard(
                      title: profile.foodsToLimit.title,
                      icon: Icons.remove_circle_outline,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _FoodChipWrap(items: profile.foodsToLimit.items),
                          const SizedBox(height: 12),
                          Text(
                            profile.foodsToLimit.rationale,
                            style: const TextStyle(
                              color: Color(0xFF5A5566),
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    _SectionCard(
                      title: 'Sample Meal Plan',
                      icon: Icons.breakfast_dining,
                      child: Column(
                        children: profile.sampleMealPlan
                            .map((meal) => _MealBlock(meal: meal))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _RecipeSpotlightCard(recipe: profile.recipeOfTheDay),
                    const SizedBox(height: 18),
                    _SectionCard(
                      title: 'Why This Phase Matters',
                      icon: Icons.menu_book_outlined,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.phaseDescription,
                            style: const TextStyle(
                              height: 1.5,
                              color: Color(0xFF30263F),
                            ),
                          ),
                          const SizedBox(height: 14),
                          ...profile.hormoneTrends.take(2).map(
                                (trend) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.arrow_right_alt,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          trend.note,
                                          style: const TextStyle(
                                            color: Color(0xFF5A5566),
                                            height: 1.4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        ],
                      ),
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
  const _SectionCard({
    required this.title,
    required this.child,
    this.icon,
  });

  final String title;
  final Widget child;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                ],
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: Color(0xFF251B38),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({
    required this.phase,
    required this.description,
  });

  final String phase;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF4EEFF), Colors.white],
        ),
        border: Border.all(color: const Color(0xFFE5D7FF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFEADFFF),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '$phase Phase Overview',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Color(0xFF30263F),
            ),
          ),
        ],
      ),
    );
  }
}

class _HormoneRow extends StatelessWidget {
  const _HormoneRow({required this.trend});

  final HormoneTrend trend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F4FB),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              trend.hormone,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Color(0xFF251B38),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              trend.trend,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              trend.note,
              style: const TextStyle(
                color: Color(0xFF5A5566),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NutrientRow extends StatelessWidget {
  const _NutrientRow({required this.item});

  final NutrientGuidance item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F4FB),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.name,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: Color(0xFF251B38),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              item.benefit,
              style: const TextStyle(
                height: 1.45,
                color: Color(0xFF5A5566),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: item.foodSources
                  .map((source) => _FoodTag(label: source))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _FoodChipWrap extends StatelessWidget {
  const _FoodChipWrap({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items.map((item) => _FoodTag(label: item)).toList(),
    );
  }
}

class _FoodTag extends StatelessWidget {
  const _FoodTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EBFB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF42305F),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MealBlock extends StatelessWidget {
  const _MealBlock({required this.meal});

  final MealPlanDay meal;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F4FB),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            meal.mealType,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            meal.title,
            style: const TextStyle(
              color: Color(0xFF251B38),
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: meal.items.map((item) => _FoodTag(label: item)).toList(),
          ),
        ],
      ),
    );
  }
}

class _RecipeSpotlightCard extends StatelessWidget {
  const _RecipeSpotlightCard({required this.recipe});

  final RecipeSpotlight recipe;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6A38B7), Color(0xFF8A5CDD)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x286A38B7),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.menu_book, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Recipe Spotlight',
                style: TextStyle(
                  color: Color(0xFFEFE4FF),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            recipe.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            recipe.summary,
            style: const TextStyle(
              color: Color(0xFFF1EBFF),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _RecipeMetaPill(
                  label: 'Prep Time',
                  value: recipe.prepTime,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _RecipeMetaPill(
                  label: 'Servings',
                  value: recipe.servings,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: recipe.benefits
                .map(
                  (benefit) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                    decoration: BoxDecoration(
                      color: const Color(0x20FFFFFF),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0x35FFFFFF)),
                    ),
                    child: Text(
                      benefit,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _RecipeMetaPill extends StatelessWidget {
  const _RecipeMetaPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0x1EFFFFFF),
        borderRadius: BorderRadius.circular(16),
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
