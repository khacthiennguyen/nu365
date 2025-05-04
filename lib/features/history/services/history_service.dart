import 'package:nu365/core/data/runtime/runtime_memory_storage.dart';
import 'package:nu365/core/data/supabase/supabase_service.dart';
import 'package:nu365/features/history/logic/history_state.dart';
import 'package:nu365/features/history/models/meal.dart';
import 'package:nu365/features/history/models/food_item.dart';
import 'package:nu365/setup_service_locator.dart';

class HistoryService {
  Future<HistoryState> loadHistory() async {
    final supabase = sl<SupabaseService>().client;
    final sessionData =
        RuntimeMemoryStorage.get<Map<String, dynamic>>('session');
    final userId = sessionData?['uId'] as String?;

    if (userId == null) {
      return const HistoryError(errorMessage: 'User not authenticated');
    }

    try {
      // Lấy danh sách các bữa ăn
      final mealsResponse = await supabase
          .from('meal')
          .select('meal_id, meal_time, note, meal_detection_id')
          .eq('user_id', userId)
          .order('meal_time', ascending: false);

      if (mealsResponse == null) {
        return const HistoryError(errorMessage: 'Failed to load meals');
      }

      final List<MealModel> meals = [];

      // Xử lý từng bữa ăn để tính toán tổng dinh dưỡng
      for (final mealData in mealsResponse) {
        final mealId = mealData['meal_id'] as String;
        final mealDetectionId = mealData['meal_detection_id'] as String?;

        String? imageUrl;

        // Lấy ảnh từ meal_detection thông qua meal_detection_id
        if (mealDetectionId != null) {
          final imageResponse = await supabase
              .from('meal_detection')
              .select('image_url')
              .eq('meal_detection_id', mealDetectionId)
              .single()
              .catchError((_) => null);

          imageUrl = imageResponse != null
              ? imageResponse['image_url'] as String?
              : null;
        }

        // Truy vấn thông tin chi tiết các món ăn trong bữa ăn
        final mealItemsResponse = await supabase
            .from('meal_item')
            .select(
                'meal_item_id, quantity, food_id, food(food_id, name, calories, protein, fat, carbs)')
            .eq('meal_id', mealId);

        final List<FoodItem> foodItems = [];
        double totalCalories = 0;
        double totalProtein = 0;
        double totalFat = 0;
        double totalCarb = 0;

        for (final itemData in mealItemsResponse) {
          final foodData = itemData['food'] as Map<String, dynamic>;
          final quantity = (itemData['quantity'] as num).toDouble();

          final calories = (foodData['calories'] as num?)?.toDouble() ?? 0;
          final protein = (foodData['protein'] as num?)?.toDouble() ?? 0;
          final fat = (foodData['fat'] as num?)?.toDouble() ?? 0;
          final carbs = (foodData['carbs'] as num?)?.toDouble() ?? 0;

          totalCalories += calories * quantity;
          totalProtein += protein * quantity;
          totalFat += fat * quantity;
          totalCarb += carbs * quantity;

          foodItems.add(FoodItem(
            food_id: foodData['food_id'] as String?, // Thêm food_id
            foodName: foodData['name'] as String,
            calories: calories,
            protein: protein,
            fat: fat,
            carb: carbs,
            quantity: quantity.toInt(),
          ));
        }

        meals.add(MealModel(
          meal_id: mealId,
          meal_time: DateTime.parse(mealData['meal_time']),
          note: mealData['note'] as String?,
          image_url: imageUrl,
          food_items: foodItems,
          total_calories: totalCalories,
          total_protein: totalProtein,
          total_fat: totalFat,
          total_carb: totalCarb,
        ));
      }

      return HistoryLoaded(meals: meals);
    } catch (e) {
      print('Error loading history: $e');
      return HistoryError(errorMessage: e.toString());
    }
  }

  Future<bool> deleteMeal(String mealId) async {
    final supabase = sl<SupabaseService>().client;
    final sessionData =
        RuntimeMemoryStorage.get<Map<String, dynamic>>('session');
    final userId = sessionData?['uId'] as String?;

    if (userId == null) {
      return false;
    }

    try {
      // Xóa bữa ăn - cascade delete sẽ xóa tất cả các mục liên quan
      await supabase
          .from('meal')
          .delete()
          .eq('meal_id', mealId)
          .eq('user_id', userId);

      return true;
    } catch (e) {
      print('Error deleting meal: $e');
      return false;
    }
  }

  Future<MealModel?> getMealDetail(String mealId) async {
    final supabase = sl<SupabaseService>().client;
    final sessionData =
        RuntimeMemoryStorage.get<Map<String, dynamic>>('session');
    final userId = sessionData?['uId'] as String?;

    if (userId == null) {
      return null;
    }

    try {
      // Lấy thông tin bữa ăn
      final mealResponse = await supabase
          .from('meal')
          .select('meal_id, meal_time, note, meal_detection_id')
          .eq('meal_id', mealId)
          .eq('user_id', userId)
          .single();

      if (mealResponse == null) {
        return null;
      }

      String? imageUrl;
      final mealDetectionId = mealResponse['meal_detection_id'] as String?;

      // Lấy ảnh từ meal_detection thông qua meal_detection_id
      if (mealDetectionId != null) {
        final imageResponse = await supabase
            .from('meal_detection')
            .select('image_url')
            .eq('meal_detection_id', mealDetectionId)
            .single()
            .catchError((_) => null);

        imageUrl = imageResponse != null
            ? imageResponse['image_url'] as String?
            : null;
      }

      // Truy vấn thông tin chi tiết các món ăn trong bữa ăn
      final mealItemsResponse = await supabase
          .from('meal_item')
          .select(
              'meal_item_id, quantity, food_id, food(food_id, name, calories, protein, fat, carbs)')
          .eq('meal_id', mealId);

      final List<FoodItem> foodItems = [];
      double totalCalories = 0;
      double totalProtein = 0;
      double totalFat = 0;
      double totalCarb = 0;

      for (final itemData in mealItemsResponse) {
        final foodData = itemData['food'] as Map<String, dynamic>;
        final quantity = (itemData['quantity'] as num).toDouble();

        final calories = (foodData['calories'] as num?)?.toDouble() ?? 0;
        final protein = (foodData['protein'] as num?)?.toDouble() ?? 0;
        final fat = (foodData['fat'] as num?)?.toDouble() ?? 0;
        final carbs = (foodData['carbs'] as num?)?.toDouble() ?? 0;

        totalCalories += calories * quantity;
        totalProtein += protein * quantity;
        totalFat += fat * quantity;
        totalCarb += carbs * quantity;

        foodItems.add(FoodItem(
          food_id: foodData['food_id'] as String?, // Thêm food_id
          foodName: foodData['name'] as String,
          calories: calories,
          protein: protein,
          fat: fat,
          carb: carbs,
          quantity: quantity.toInt(),
        ));
      }

      return MealModel(
        meal_id: mealId,
        meal_time: DateTime.parse(mealResponse['meal_time']),
        note: mealResponse['note'] as String?,
        image_url: imageUrl,
        food_items: foodItems,
        total_calories: totalCalories,
        total_protein: totalProtein,
        total_fat: totalFat,
        total_carb: totalCarb,
      );
    } catch (e) {
      print('Error getting meal detail: $e');
      return null;
    }
  }
}
