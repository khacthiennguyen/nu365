
import 'package:nu365/features/dashboard/models/dashboard_data.dart';
import 'package:nu365/features/dashboard/models/meal_summary.dart';
import 'package:nu365/features/dashboard/models/nutrition_goals.dart';
import 'package:nu365/features/dashboard/models/nutrition_log.dart';
import 'package:nu365/features/dashboard/models/weekly_nutrition_data.dart';
import 'package:nu365/features/history/logic/history_state.dart';
import 'package:nu365/features/history/models/meal.dart';
import 'package:nu365/features/history/services/history_service.dart';
import 'package:nu365/features/profile/logic/settings_state.dart';
import 'package:nu365/features/profile/models/user_info.dart';
import 'package:nu365/features/profile/services/settings_services.dart';
import 'package:nu365/setup_service_locator.dart';

class DashboardService {
  final _historyService = sl<HistoryService>();
  final _settingsService = sl<SettingsServices>();

  Future<DashboardData> loadDashboardData() async {
    try {
      // Fetch user information including nutrition goals
      final SettingsState settingsState = await _settingsService.loadUserInfo();

      // Fetch meal history
      final HistoryState historyState = await _historyService.loadHistory();

      // Extract user nutrition goals
      NutritionGoals goals = NutritionGoals.empty();
      if (settingsState is LoadInfoUserSuccess) {
        final UserInfo userInfo = settingsState.userInfo;
        goals = NutritionGoals(
          calories: userInfo.goal_calories ?? 2000.0,
          protein: userInfo.goal_protein ?? 100.0,
          fat: userInfo.goal_fat ?? 70.0,
          carbs: userInfo.goal_carbs ?? 250.0,
        );
      }

      if (historyState is HistoryLoaded) {
        final List<MealModel> meals = historyState.meals;

        // Convert meals to map format for data processing
        final List<Map<String, dynamic>> mealMaps = meals
            .map((meal) => {
                  'meal_id': meal.meal_id,
                  'meal_time': meal.meal_time.toIso8601String(),
                  'image_url': meal.image_url,
                  'note': meal.note,
                  'total_calories': meal.total_calories,
                  'total_protein': meal.total_protein,
                  'total_fat': meal.total_fat,
                  'total_carb': meal.total_carb,
                  'food_items': meal.food_items,
                })
            .toList();

        // Calculate today's nutrition values
        final todayMeals = _getTodayMeals(mealMaps);
        final NutritionLog todayNutrition = NutritionLog.fromMeals(todayMeals);

        // Calculate weekly nutrition data
        final WeeklyNutritionData weeklyNutrition =
            WeeklyNutritionData.fromMeals(mealMaps);

        // Create meal summaries for recent meals
        final List<MealSummary> recentMeals = _createRecentMealSummaries(meals);

        return DashboardData(
          goals: goals,
          todayNutrition: todayNutrition,
          weeklyNutrition: weeklyNutrition,
          recentMeals: recentMeals,
        );
      }

      // Return empty data if history couldn't be loaded
      return DashboardData.empty();
    } catch (e) {
      print('Error loading dashboard data: $e');
      return DashboardData.empty();
    }
  }

  List<Map<String, dynamic>> _getTodayMeals(List<Map<String, dynamic>> meals) {
    final today = DateTime.now();
    final startOfToday = DateTime(today.year, today.month, today.day);

    return meals.where((meal) {
      final mealTime = DateTime.parse(meal['meal_time']);
      return mealTime.isAfter(startOfToday) ||
          mealTime.isAtSameMomentAs(startOfToday);
    }).toList();
  }

  List<MealSummary> _createRecentMealSummaries(List<MealModel> meals) {
    // Sort meals by date (most recent first) and take the first 5
    final sortedMeals = List<MealModel>.from(meals)
      ..sort((a, b) => b.meal_time.compareTo(a.meal_time));

    final recentMeals = sortedMeals.take(5).toList();

    return recentMeals
        .map((meal) => MealSummary(
              mealId: meal.meal_id,
              mealTime: meal.meal_time,
              imageUrl: meal.image_url,
              note: meal.note,
              totalCalories: meal.total_calories ?? 0.0,
              totalProtein: meal.total_protein ?? 0.0,
              totalFat: meal.total_fat ?? 0.0,
              totalCarb: meal.total_carb ?? 0.0,
              foodItemCount: meal.food_items!.length,
            ))
        .toList();
  }
}
