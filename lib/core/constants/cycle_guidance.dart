class CycleGuidance {
  static const Map<String, List<String>> nutritionByPhase = {
    'Menstrual': [
      'Iron-rich foods such as beans, spinach, and lentils',
      'Vitamin C foods to support iron absorption',
      'Steady hydration throughout the day',
    ],
    'Follicular': [
      'Balanced carbohydrates for sustained energy',
      'Lean protein at each meal',
      'Colorful produce for micronutrients',
    ],
    'Ovulatory': [
      'High-fiber vegetables and whole grains',
      'Omega-3 rich options like salmon or walnuts',
      'Hydration with electrolytes when active',
    ],
    'Luteal': [
      'Magnesium-rich foods like pumpkin seeds and almonds',
      'Protein with each meal to support satiety',
      'Hydration and lower-sodium choices',
    ],
  };

  static const Map<String, String> activityByPhase = {
    'Menstrual':
        'Gentle movement such as walking, stretching, and low-impact yoga.',
    'Follicular':
        'Progressive strength sessions, intervals, and skill-based training.',
    'Ovulatory':
        'Higher-intensity workouts, power training, and social movement classes.',
    'Luteal':
        'Moderate strength training, walking, and mobility-focused sessions.',
  };
}
