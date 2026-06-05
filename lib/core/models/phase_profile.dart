class PhaseProfile {
  const PhaseProfile({
    required this.phaseName,
    required this.phaseDescription,
    required this.hormoneTrends,
    required this.priorityNutrients,
    required this.foodsToPrioritize,
    required this.foodsToLimit,
    required this.activityFocus,
    required this.sampleMealPlan,
    required this.recipeOfTheDay,
  });

  final String phaseName;
  final String phaseDescription;
  final List<HormoneTrend> hormoneTrends;
  final List<NutrientGuidance> priorityNutrients;
  final FoodGuidance foodsToPrioritize;
  final FoodGuidance foodsToLimit;
  final ActivityGuidance activityFocus;
  final List<MealPlanDay> sampleMealPlan;
  final RecipeSpotlight recipeOfTheDay;
}

class HormoneTrend {
  const HormoneTrend({
    required this.hormone,
    required this.trend,
    required this.note,
  });

  final String hormone;
  final String trend;
  final String note;

  String get summary => '$hormone: $trend';
}

class NutrientGuidance {
  const NutrientGuidance({
    required this.name,
    required this.benefit,
    required this.foodSources,
  });

  final String name;
  final String benefit;
  final List<String> foodSources;

  String get summary => '$name - $benefit';
}

class FoodGuidance {
  const FoodGuidance({
    required this.title,
    required this.items,
    required this.rationale,
  });

  final String title;
  final List<String> items;
  final String rationale;
}

class ActivityGuidance {
  const ActivityGuidance({
    required this.summary,
    required this.examples,
  });

  final String summary;
  final List<String> examples;
}

class MealPlanDay {
  const MealPlanDay({
    required this.mealType,
    required this.title,
    required this.items,
    this.note = '',
  });

  final String mealType;
  final String title;
  final List<String> items;
  final String note;
}

class RecipeSpotlight {
  const RecipeSpotlight({
    required this.title,
    required this.summary,
    required this.prepTime,
    required this.servings,
    required this.benefits,
    required this.ingredients,
    required this.instructionsSummary,
  });

  final String title;
  final String summary;
  final String prepTime;
  final String servings;
  final List<String> benefits;
  final List<String> ingredients;
  final List<String> instructionsSummary;
}
