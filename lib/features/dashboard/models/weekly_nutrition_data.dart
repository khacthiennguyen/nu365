class WeeklyNutritionData {
  final Map<String, List<double>> data;

  WeeklyNutritionData({
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return data;
  }

  factory WeeklyNutritionData.empty() {
    return WeeklyNutritionData(
      data: {
        'calories': List.filled(7, 0.0),
        'protein': List.filled(7, 0.0),
        'fat': List.filled(7, 0.0),
        'carbs': List.filled(7, 0.0),
      },
    );
  }

  factory WeeklyNutritionData.fromMeals(List<Map<String, dynamic>> meals) {
    // Initialize with zeros for 7 days
    Map<String, List<double>> weeklyData = {
      'calories': List.filled(7, 0.0),
      'protein': List.filled(7, 0.0),
      'fat': List.filled(7, 0.0),
      'carbs': List.filled(7, 0.0),
    };

    // Get the current date
    DateTime now = DateTime.now();
    // Calculate the date 6 days ago (for a 7-day period)
    DateTime weekStart = DateTime(now.year, now.month, now.day - 6);

    for (var meal in meals) {
      DateTime mealTime = DateTime.parse(meal['meal_time']);
      // Check if the meal is within the last 7 days
      if (mealTime.isAfter(weekStart) || mealTime.isAtSameMomentAs(weekStart)) {
        // Calculate day index (0-6) from the start of the week
        int dayIndex = mealTime.difference(weekStart).inDays;
        if (dayIndex >= 0 && dayIndex < 7) {
          // Add meal nutrition to the correct day
          weeklyData['calories']![dayIndex] +=
              (meal['total_calories'] as num?)?.toDouble() ?? 0;
          weeklyData['protein']![dayIndex] +=
              (meal['total_protein'] as num?)?.toDouble() ?? 0;
          weeklyData['fat']![dayIndex] +=
              (meal['total_fat'] as num?)?.toDouble() ?? 0;
          weeklyData['carbs']![dayIndex] +=
              (meal['total_carb'] as num?)?.toDouble() ?? 0;
        }
      }
    }

    return WeeklyNutritionData(data: weeklyData);
  }
}
