class NutritionGoals {
  final double calories;
  final double protein;
  final double fat;
  final double carbs;

  NutritionGoals({
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

  factory NutritionGoals.fromJson(Map<String, dynamic> json) {
    return NutritionGoals(
      calories: json['goal_calories']?.toDouble() ?? 2000.0,
      protein: json['goal_protein']?.toDouble() ?? 100.0,
      fat: json['goal_fat']?.toDouble() ?? 70.0,
      carbs: json['goal_carbs']?.toDouble() ?? 250.0,
    );
  }

  factory NutritionGoals.empty() {
    return NutritionGoals(
      calories: 2000.0,
      protein: 100.0,
      fat: 70.0,
      carbs: 250.0,
    );
  }

  double getProgress(String nutrient, double consumed) {
    switch (nutrient) {
      case 'calories':
        return calories > 0 ? consumed / calories : 0;
      case 'protein':
        return protein > 0 ? consumed / protein : 0;
      case 'fat':
        return fat > 0 ? consumed / fat : 0;
      case 'carbs':
        return carbs > 0 ? consumed / carbs : 0;
      default:
        return 0;
    }
  }
}
