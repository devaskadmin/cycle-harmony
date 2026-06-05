import '../models/phase_profile.dart';

class CycleGuidance {
  static const Map<String, PhaseProfile> phaseProfiles = {
    'Menstrual': PhaseProfile(
      phaseName: 'Menstrual',
      phaseDescription:
          'Menstrual phase is the reset point of the cycle. Estrogen and progesterone are at their lowest, bleeding is active or tapering, and energy can feel more inward, slower, or variable. The most useful strategy here is gentle replenishment: support iron status, hydrate well, keep meals easy to digest, and let recovery lead the plan.',
      hormoneTrends: [
        HormoneTrend(
          hormone: 'Estrogen',
          trend: 'Low at the start, then gradually begins to rise',
          note:
              'A slow rebound can support a steadier return of energy, appetite, and training tolerance.',
        ),
        HormoneTrend(
          hormone: 'Progesterone',
          trend: 'Low',
          note:
              'The drop in progesterone is part of what triggers menstruation.',
        ),
        HormoneTrend(
          hormone: 'LH',
          trend: 'Quiet and low',
          note:
              'Luteinizing hormone is not driving major reproductive activity in this window.',
        ),
      ],
      priorityNutrients: [
        NutrientGuidance(
          name: 'Iron',
          benefit:
              'Important for replacing iron lost through bleeding and for supporting oxygen transport, stamina, and overall energy feel.',
          foodSources: ['Lentils', 'Spinach', 'Beans', 'Lean red meat'],
        ),
        NutrientGuidance(
          name: 'Vitamin C',
          benefit:
              'Pairs with iron-rich foods to improve absorption, especially from plant sources.',
          foodSources: ['Citrus', 'Kiwi', 'Bell peppers', 'Strawberries'],
        ),
        NutrientGuidance(
          name: 'Omega-3 fats',
          benefit:
              'Helpful for a balanced inflammatory response and for meals that feel satisfying without being heavy.',
          foodSources: ['Salmon', 'Sardines', 'Chia seeds', 'Walnuts'],
        ),
        NutrientGuidance(
          name: 'Magnesium',
          benefit:
              'Supports muscle relaxation, hydration balance, and a calmer meal pattern when cramps or fatigue are top of mind.',
          foodSources: [
            'Pumpkin seeds',
            'Dark chocolate',
            'Almonds',
            'Spinach'
          ],
        ),
      ],
      foodsToPrioritize: FoodGuidance(
        title: 'Foods to Prioritize',
        items: [
          'Iron-rich meals paired with vitamin C',
          'Soups, stews, and warm bowls',
          'Leafy greens, beans, and lentils',
          'Hydrating fruit and mineral-rich fluids'
        ],
        rationale:
            'These choices are easier to tolerate when appetite is lower, and they help restore nutrients while keeping digestion and hydration steady.',
      ),
      foodsToLimit: FoodGuidance(
        title: 'Foods to Limit',
        items: [
          'Highly processed snacks',
          'Excess alcohol',
          'Very salty convenience foods',
          'Large caffeine doses on an empty stomach'
        ],
        rationale:
            'These can work against hydration, irritate an already sensitive stomach, and make energy swings feel sharper.',
      ),
      activityFocus: ActivityGuidance(
        summary:
            'Recovery-first movement is the priority: keep strength lighter, choose lower-impact cardio, and use mobility to reduce stiffness. On high-fatigue days, a walk, breathwork, or restorative yoga may be the best session of all.',
        examples: [
          'Recovery: restorative yoga, breathing, and easy walks',
          'Strength: light technique work or deload sessions',
          'Cardio: low-intensity Zone 2 or short walks',
          'Mobility: hips, lower back, rib cage, and hamstrings'
        ],
      ),
      sampleMealPlan: [
        MealPlanDay(
          mealType: 'Breakfast',
          title: 'Warm Oat Bowl with Berries',
          items: [
            'Oats',
            'Greek yogurt',
            'Chia seeds',
            'Berries',
            'Pumpkin seeds'
          ],
        ),
        MealPlanDay(
          mealType: 'Lunch',
          title: 'Lentil Recovery Bowl',
          items: [
            'Lentils',
            'Spinach',
            'Roasted carrots',
            'Quinoa',
            'Lemon vinaigrette'
          ],
        ),
        MealPlanDay(
          mealType: 'Snack',
          title: 'Citrus Yogurt Cup',
          items: ['Yogurt', 'Orange segments', 'Honey', 'Walnuts'],
        ),
        MealPlanDay(
          mealType: 'Dinner',
          title: 'Salmon, Sweet Potato, and Greens',
          items: ['Salmon', 'Sweet potato', 'Sautéed kale', 'Olive oil'],
        ),
      ],
      recipeOfTheDay: RecipeSpotlight(
        title: 'Citrus Lentil Soup',
        summary:
            'A cozy one-pot soup that feels practical on low-energy days and still delivers a premium, nourishing finish.',
        prepTime: '35 min',
        servings: '4 servings',
        benefits: [
          'Iron-rich base for replenishment',
          'Vitamin C finish for absorption support',
          'Hydrating, savory, and easy to batch cook'
        ],
        ingredients: [
          'Brown lentils',
          'Carrots',
          'Celery',
          'Onion',
          'Garlic',
          'Lemon',
          'Spinach',
          'Vegetable broth'
        ],
        instructionsSummary: [
          'Sauté onion, garlic, and vegetables',
          'Simmer lentils in broth until tender',
          'Finish with lemon and spinach, then serve with toast or crackers'
        ],
      ),
    ),
    'Follicular': PhaseProfile(
      phaseName: 'Follicular',
      phaseDescription:
          'Follicular phase is the rebuilding and momentum phase. Estrogen is climbing, which often coincides with better energy, sharper focus, and more appetite for structure, variety, and productive training. Nutritionally, this is a strong time to lean into protein, fiber, and colorful meals that support recovery and consistent energy.',
      hormoneTrends: [
        HormoneTrend(
          hormone: 'Estrogen',
          trend: 'Rising steadily',
          note:
              'Often aligns with a more energetic, optimistic, and training-ready feel.',
        ),
        HormoneTrend(
          hormone: 'FSH',
          trend: 'Active early in the phase',
          note:
              'Supports follicle development and the progression toward ovulation.',
        ),
        HormoneTrend(
          hormone: 'Progesterone',
          trend: 'Still relatively low',
          note:
              'Lower progesterone often means less of the slower, heavier feeling associated with the luteal phase.',
        ),
      ],
      priorityNutrients: [
        NutrientGuidance(
          name: 'Protein',
          benefit:
              'Supports lean tissue repair, helps anchor meal satisfaction, and pairs well with the phase’s higher training capacity.',
          foodSources: ['Greek yogurt', 'Eggs', 'Chicken', 'Tofu'],
        ),
        NutrientGuidance(
          name: 'Fiber',
          benefit:
              'Helps with fullness, digestive regularity, and smoother blood sugar after meals.',
          foodSources: ['Berries', 'Oats', 'Beans', 'Vegetables'],
        ),
        NutrientGuidance(
          name: 'B vitamins',
          benefit:
              'Help the body convert food into usable energy, which matters when training volume or schedule complexity starts to climb.',
          foodSources: ['Whole grains', 'Eggs', 'Leafy greens', 'Legumes'],
        ),
        NutrientGuidance(
          name: 'Folate',
          benefit:
              'Supports cell growth and works well with the phase’s focus on rebuilding and readiness.',
          foodSources: ['Leafy greens', 'Avocado', 'Beans', 'Citrus'],
        ),
      ],
      foodsToPrioritize: FoodGuidance(
        title: 'Foods to Prioritize',
        items: [
          'Lean proteins at each meal',
          'Colorful produce and raw crunch',
          'Whole grains and legumes',
          'Fermented foods for variety and digestion'
        ],
        rationale:
            'These foods match the phase’s upward energy curve and make it easier to build balanced meals that support training and focus.',
      ),
      foodsToLimit: FoodGuidance(
        title: 'Foods to Limit',
        items: [
          'Very heavy fried foods',
          'Large refined-sugar spikes',
          'Skipping meals',
          'Highly erratic eating windows'
        ],
        rationale:
            'Keeping meals steady helps maintain the phase’s better energy, steady mood, and training quality.',
      ),
      activityFocus: ActivityGuidance(
        summary:
            'This is an ideal window for building capacity: recovery is still important, strength work can progress, cardio can be more ambitious, and mobility can support higher training volume.',
        examples: [
          'Recovery: normal sleep, hydration, and post-workout refueling',
          'Strength: progressive overload and skill practice',
          'Cardio: intervals, tempo work, or longer steady sessions',
          'Mobility: dynamic warm-ups and full-range hip/shoulder work'
        ],
      ),
      sampleMealPlan: [
        MealPlanDay(
          mealType: 'Breakfast',
          title: 'Greek Yogurt Parfait with Citrus',
          items: [
            'Greek yogurt',
            'Berries',
            'Granola',
            'Pumpkin seeds',
            'Orange zest'
          ],
        ),
        MealPlanDay(
          mealType: 'Lunch',
          title: 'Chicken Grain Bowl',
          items: [
            'Chicken',
            'Brown rice',
            'Avocado',
            'Mixed greens',
            'Tahini dressing'
          ],
        ),
        MealPlanDay(
          mealType: 'Snack',
          title: 'Apple, Hummus, and Seeds',
          items: ['Apple slices', 'Hummus', 'Sunflower seeds'],
        ),
        MealPlanDay(
          mealType: 'Dinner',
          title: 'Tofu Stir-Fry with Soba Noodles',
          items: [
            'Tofu',
            'Broccoli',
            'Bell peppers',
            'Soba noodles',
            'Sesame oil'
          ],
        ),
      ],
      recipeOfTheDay: RecipeSpotlight(
        title: 'Berry Protein Parfait',
        summary:
            'A bright, fast breakfast or snack that feels fresh but still delivers enough structure to support a productive day.',
        prepTime: '10 min',
        servings: '1 serving',
        benefits: [
          'High protein for recovery and satiety',
          'Fiber and antioxidants from fruit',
          'Easy to scale into a pre- or post-workout meal'
        ],
        ingredients: [
          'Greek yogurt',
          'Mixed berries',
          'Granola',
          'Chia seeds',
          'Honey',
          'Orange zest'
        ],
        instructionsSummary: [
          'Layer yogurt, berries, and granola in a glass or bowl',
          'Add chia seeds, a light drizzle of honey, and orange zest',
          'Serve chilled with coffee or tea if desired'
        ],
      ),
    ),
    'Ovulatory': PhaseProfile(
      phaseName: 'Ovulatory',
      phaseDescription:
          'Ovulatory phase is the peak-and-release moment of the cycle. Estrogen reaches its high point and luteinizing hormone surges to trigger ovulation. Many people feel socially engaged, strong, and responsive to more intense training, but recovery and hydration still matter because output can rise quickly.',
      hormoneTrends: [
        HormoneTrend(
          hormone: 'Estrogen',
          trend: 'Peaking',
          note:
              'Often aligns with heightened energy, confidence, and a stronger training response.',
        ),
        HormoneTrend(
          hormone: 'LH',
          trend: 'Surging around ovulation',
          note:
              'This surge is the signal that releases the egg and shifts the cycle forward.',
        ),
        HormoneTrend(
          hormone: 'Progesterone',
          trend: 'Begins to rise after ovulation',
          note:
              'Starts setting up the luteal phase and the more structured recovery needs that follow.',
        ),
      ],
      priorityNutrients: [
        NutrientGuidance(
          name: 'Antioxidants',
          benefit:
              'Support recovery from higher output, especially when training intensity or social activity is up.',
          foodSources: ['Berries', 'Leafy greens', 'Citrus', 'Tomatoes'],
        ),
        NutrientGuidance(
          name: 'Omega-3 fats',
          benefit:
              'Support a balanced inflammatory response and help build meals that feel premium and satisfying.',
          foodSources: ['Salmon', 'Walnuts', 'Flaxseed', 'Chia seeds'],
        ),
        NutrientGuidance(
          name: 'Hydration and electrolytes',
          benefit:
              'Important for performance, temperature regulation, and recovery when training sessions feel more intense.',
          foodSources: ['Water', 'Electrolyte drinks', 'Coconut water'],
        ),
        NutrientGuidance(
          name: 'Zinc',
          benefit:
              'Supports normal reproductive and immune function and appears often in protein-rich meal patterns.',
          foodSources: ['Pumpkin seeds', 'Beef', 'Chickpeas', 'Yogurt'],
        ),
      ],
      foodsToPrioritize: FoodGuidance(
        title: 'Foods to Prioritize',
        items: [
          'Hydrating produce and juicy fruit',
          'Lean protein and seafood',
          'Whole grains and seed-rich sides',
          'Healthy fats for satiety and flavor'
        ],
        rationale:
            'These foods support the phase’s higher energy output while keeping recovery, fullness, and nutrient density high.',
      ),
      foodsToLimit: FoodGuidance(
        title: 'Foods to Limit',
        items: [
          'Dehydrating excess caffeine',
          'Skipping recovery meals',
          'Ultra-processed snacks',
          'Alcohol-heavy social meals without balance'
        ],
        rationale:
            'Keeping hydration and refueling consistent supports the peak-output feel of this phase and reduces the crash that can follow.',
      ),
      activityFocus: ActivityGuidance(
        summary:
            'This is a strong phase for confident training: recovery should be intentional, strength can be more explosive, cardio can include intervals or faster efforts, and mobility should stay in the warm-up and cool-down.',
        examples: [
          'Recovery: refuel promptly and preserve sleep quality',
          'Strength: heavier lifts, power work, and skill sessions',
          'Cardio: intervals, hill work, or energetic classes',
          'Mobility: dynamic warm-ups, thoracic rotation, and hip openers'
        ],
      ),
      sampleMealPlan: [
        MealPlanDay(
          mealType: 'Breakfast',
          title: 'Green Smoothie and Toast',
          items: [
            'Spinach',
            'Banana',
            'Protein powder',
            'Whole-grain toast',
            'Nut butter'
          ],
        ),
        MealPlanDay(
          mealType: 'Lunch',
          title: 'Salmon Crunch Salad',
          items: [
            'Salmon',
            'Cucumber',
            'Quinoa',
            'Seeds',
            'Citrus dressing',
            'Avocado'
          ],
        ),
        MealPlanDay(
          mealType: 'Snack',
          title: 'Trail Mix and Fruit',
          items: ['Walnuts', 'Pumpkin seeds', 'Dried cherries', 'Apple'],
        ),
        MealPlanDay(
          mealType: 'Dinner',
          title: 'Chicken and Veggie Bowl',
          items: [
            'Chicken',
            'Roasted vegetables',
            'Farro',
            'Tahini drizzle',
            'Herbs'
          ],
        ),
      ],
      recipeOfTheDay: RecipeSpotlight(
        title: 'Citrus Salmon Salad',
        summary:
            'A bright, restaurant-style lunch that feels elevated while still fitting a practical training day.',
        prepTime: '20 min',
        servings: '2 servings',
        benefits: [
          'Omega-3 rich for recovery support',
          'Hydrating and refreshing',
          'Balanced enough for lunch or post-workout'
        ],
        ingredients: [
          'Salmon',
          'Mixed greens',
          'Cucumber',
          'Orange segments',
          'Olive oil',
          'Pumpkin seeds',
          'Lemon'
        ],
        instructionsSummary: [
          'Cook salmon until just flaky and season simply',
          'Assemble greens, cucumber, orange segments, and seeds',
          'Finish with lemon-olive oil dressing and serve with bread or grains if desired'
        ],
      ),
    ),
    'Luteal': PhaseProfile(
      phaseName: 'Luteal',
      phaseDescription:
          'Luteal phase is the structure-and-stability phase. Progesterone is higher after ovulation and appetite often becomes more noticeable, so the most helpful approach is consistent meals, steady blood sugar support, and a little more attention to comfort foods that still feel nourishing.',
      hormoneTrends: [
        HormoneTrend(
          hormone: 'Progesterone',
          trend: 'Rising then falling later in the phase',
          note:
              'Supports the uterine lining and is linked with changes in temperature, appetite, and perceived energy.',
        ),
        HormoneTrend(
          hormone: 'Estrogen',
          trend: 'Moderate with a later decline',
          note:
              'Often stays moderate early in the phase, then drops closer to menstruation.',
        ),
        HormoneTrend(
          hormone: 'LH',
          trend: 'Low after ovulation',
          note:
              'The ovulatory surge has passed, so the hormonal emphasis shifts toward maintaining and preparing for the next cycle.',
        ),
      ],
      priorityNutrients: [
        NutrientGuidance(
          name: 'Magnesium',
          benefit:
              'Supports muscle relaxation, sleep quality, and a steadier sense of calm when the phase feels more demanding.',
          foodSources: [
            'Pumpkin seeds',
            'Almonds',
            'Dark chocolate',
            'Spinach'
          ],
        ),
        NutrientGuidance(
          name: 'Complex carbohydrates',
          benefit:
              'Help maintain steadier energy and can reduce the urge to bounce between under-eating and over-snacking.',
          foodSources: ['Sweet potatoes', 'Oats', 'Brown rice', 'Whole grains'],
        ),
        NutrientGuidance(
          name: 'Calcium',
          benefit:
              'Supports bone health and works well in a phase where whole-food, calcium-rich staples can feel grounding and practical.',
          foodSources: [
            'Greek yogurt',
            'Milk',
            'Fortified plant milks',
            'Tofu'
          ],
        ),
        NutrientGuidance(
          name: 'Vitamin B6',
          benefit:
              'Supports energy metabolism and helps round out meal patterns when cravings or mood shifts are more noticeable.',
          foodSources: ['Chickpeas', 'Bananas', 'Potatoes', 'Salmon'],
        ),
      ],
      foodsToPrioritize: FoodGuidance(
        title: 'Foods to Prioritize',
        items: [
          'Complex carbs paired with protein',
          'Magnesium-rich snacks and sides',
          'Calcium-rich breakfast and evening foods',
          'Fiber-rich produce for fuller meals'
        ],
        rationale:
            'These choices make it easier to keep energy and appetite steady, which is especially useful when cravings or late-day hunger rise.',
      ),
      foodsToLimit: FoodGuidance(
        title: 'Foods to Limit',
        items: [
          'Very salty foods',
          'Excess added sugar',
          'Large missed-meal gaps',
          'Caffeine without food'
        ],
        rationale:
            'These can intensify bloating, energy swings, and the push-pull of cravings that some people notice in the luteal phase.',
      ),
      activityFocus: ActivityGuidance(
        summary:
            'The focus shifts toward sustainable movement: keep strength training moderate, use cardio for circulation and mood support, protect recovery, and make mobility part of the daily routine.',
        examples: [
          'Recovery: sleep, hydration, and post-training refueling',
          'Strength: moderate loads and fewer all-out sessions',
          'Cardio: brisk walks, easy cycling, or light steady-state work',
          'Mobility: yoga, stretching, and decompression work'
        ],
      ),
      sampleMealPlan: [
        MealPlanDay(
          mealType: 'Breakfast',
          title: 'Oats with Nut Butter and Banana',
          items: ['Oats', 'Nut butter', 'Banana', 'Cinnamon', 'Chia seeds'],
        ),
        MealPlanDay(
          mealType: 'Lunch',
          title: 'Turkey Sweet Potato Plate',
          items: [
            'Turkey',
            'Sweet potato',
            'Broccoli',
            'Olive oil',
            'Pumpkin seeds'
          ],
        ),
        MealPlanDay(
          mealType: 'Snack',
          title: 'Apple with Yogurt Dip',
          items: ['Apple', 'Greek yogurt', 'Cinnamon', 'Walnuts'],
        ),
        MealPlanDay(
          mealType: 'Dinner',
          title: 'Bean and Veggie Chili',
          items: ['Beans', 'Tomatoes', 'Peppers', 'Brown rice', 'Avocado'],
        ),
      ],
      recipeOfTheDay: RecipeSpotlight(
        title: 'Magnesium Oat Bake',
        summary:
            'A cozy, make-ahead breakfast that feels comforting without becoming a sugar crash.',
        prepTime: '35 min',
        servings: '6 servings',
        benefits: [
          'Meal-prep friendly for busy weeks',
          'Fiber and magnesium in one dish',
          'Good warm or cold for breakfast or snack'
        ],
        ingredients: [
          'Rolled oats',
          'Bananas',
          'Almonds',
          'Milk',
          'Greek yogurt',
          'Cinnamon',
          'Pumpkin seeds'
        ],
        instructionsSummary: [
          'Mix the oats, banana, milk, yogurt, cinnamon, and chopped almonds',
          'Bake until set and lightly golden',
          'Finish with pumpkin seeds and serve warm or chilled throughout the week'
        ],
      ),
    ),
  };

  static Map<String, List<String>> get nutritionByPhase => {
        for (final entry in phaseProfiles.entries)
          entry.key: entry.value.priorityNutrients
              .map((guidance) => guidance.summary)
              .toList(),
      };

  static Map<String, String> get activityByPhase => {
        for (final entry in phaseProfiles.entries)
          entry.key: entry.value.activityFocus.summary,
      };

  static PhaseProfile profileForPhase(String phase) {
    return phaseProfiles[phase] ?? phaseProfiles['Follicular']!;
  }
}
