class NutritionLog {
  final double calories;
  final double protein;
  final double fat;
  final double carbs;
  final DateTime date;

  NutritionLog({
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'carbs': carbs,
      'date': date.toIso8601String(),
    };
  }

  factory NutritionLog.fromJson(Map<String, dynamic> json) {
    return NutritionLog(
      calories: json['calories']?.toDouble() ?? 0,
      protein: json['protein']?.toDouble() ?? 0,
      fat: json['fat']?.toDouble() ?? 0,
      carbs: json['carbs']?.toDouble() ?? 0,
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
    );
  }

  factory NutritionLog.empty() {
    return NutritionLog(
      calories: 0,
      protein: 0,
      fat: 0,
      carbs: 0,
      date: DateTime.now(),
    );
  }

  factory NutritionLog.fromMeals(List<Map<String, dynamic>> meals) {
    double totalCalories = 0;
    double totalProtein = 0;
    double totalFat = 0;
    double totalCarbs = 0;

    for (final meal in meals) {
      totalCalories += (meal['total_calories'] as num?)?.toDouble() ?? 0;
      totalProtein += (meal['total_protein'] as num?)?.toDouble() ?? 0;
      totalFat += (meal['total_fat'] as num?)?.toDouble() ?? 0;
      totalCarbs += (meal['total_carb'] as num?)?.toDouble() ?? 0;
    }

    return NutritionLog(
      calories: totalCalories,
      protein: totalProtein,
      fat: totalFat,
      carbs: totalCarbs,
      date: DateTime.now(),
    );
  }
}
