import 'package:nu365/features/dashboard/models/nutrition_goals.dart';
import 'package:nu365/features/dashboard/models/nutrition_log.dart';
import 'package:nu365/features/dashboard/models/meal_summary.dart';
import 'package:nu365/features/dashboard/models/weekly_nutrition_data.dart';

class DashboardData {
  final NutritionGoals goals;
  final NutritionLog todayNutrition;
  final WeeklyNutritionData weeklyNutrition;
  final List<MealSummary> recentMeals;

  DashboardData({
    required this.goals,
    required this.todayNutrition,
    required this.weeklyNutrition,
    required this.recentMeals,
  });

  Map<String, dynamic> toJson() {
    return {
      'goals': goals.toJson(),
      'todayNutrition': todayNutrition.toJson(),
      'weeklyNutrition': weeklyNutrition.toJson(),
      'recentMeals': recentMeals.map((meal) => meal.toJson()).toList(),
    };
  }

  factory DashboardData.empty() {
    return DashboardData(
      goals: NutritionGoals.empty(),
      todayNutrition: NutritionLog.empty(),
      weeklyNutrition: WeeklyNutritionData.empty(),
      recentMeals: [],
    );
  }
}
