class NutritionProgress {
  final double calories;
  final double protein;
  final double fat;
  final double carbs;

  NutritionProgress({
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
  });

  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'carbs': carbs,
    };
  }

  factory NutritionProgress.calculate(
    Map<String, dynamic> goals,
    Map<String, dynamic> consumed,
  ) {
    final goalCalories = (goals['calories'] as num?)?.toDouble() ?? 2000.0;
    final goalProtein = (goals['protein'] as num?)?.toDouble() ?? 100.0;
    final goalFat = (goals['fat'] as num?)?.toDouble() ?? 70.0;
    final goalCarbs = (goals['carbs'] as num?)?.toDouble() ?? 250.0;

    final consumedCalories = (consumed['calories'] as num?)?.toDouble() ?? 0.0;
    final consumedProtein = (consumed['protein'] as num?)?.toDouble() ?? 0.0;
    final consumedFat = (consumed['fat'] as num?)?.toDouble() ?? 0.0;
    final consumedCarbs = (consumed['carbs'] as num?)?.toDouble() ?? 0.0;

    return NutritionProgress(
      calories: goalCalories > 0
          ? (consumedCalories / goalCalories).clamp(0.0, 1.0)
          : 0.0,
      protein: goalProtein > 0
          ? (consumedProtein / goalProtein).clamp(0.0, 1.0)
          : 0.0,
      fat: goalFat > 0 ? (consumedFat / goalFat).clamp(0.0, 1.0) : 0.0,
      carbs: goalCarbs > 0 ? (consumedCarbs / goalCarbs).clamp(0.0, 1.0) : 0.0,
    );
  }

  factory NutritionProgress.empty() {
    return NutritionProgress(
      calories: 0.0,
      protein: 0.0,
      fat: 0.0,
      carbs: 0.0,
    );
  }
}
