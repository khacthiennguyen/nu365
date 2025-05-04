import 'dart:io';
import 'package:nu365/core/data/runtime/runtime_memory_storage.dart';
import 'package:nu365/core/data/supabase/supabase_service.dart';
import 'package:nu365/features/scan/logic/scan_state.dart';
import 'package:nu365/features/scan/models/scan_result.dart';
import 'package:nu365/setup_service_locator.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class ResultScanService {
  Future<ScanState> fetchFoodData(List<String> foodLists) async {
    try {
      // Log the detected food items for debugging
      print('🔍 Detected food items: $foodLists');

      // Count the quantity of each food item
      Map<String, int> foodCount = {};
      for (var food in foodLists) {
        foodCount[food] = (foodCount[food] ?? 0) + 1;
      }

      print('📊 Food count: $foodCount');

      // Query the food table for unique food items
      final uniqueFoodList = foodCount.keys.toList();
      print('🔎 Unique food list for query: $uniqueFoodList');

      final response = await sl<SupabaseService>()
          .client
          .from('food')
          .select('food_id, name, calories, protein, fat, carbs, class_name')
          .or(uniqueFoodList
              .map((f) => 'class_name.eq.$f')
              .join(',')); // Use class_name for querying food

      print('📋 Database response: $response');

      List<FoodInfo> foodInfo = [];

      for (var item in response as List) {
        final foodName = item['name'] as String?;
        final className = item['class_name'] as String?;

        print('🍽️ Processing item: name=$foodName, class_name=$className');

        // So sánh với class_name trong foodCount thay vì sử dụng foodName
        if (className != null && foodCount.containsKey(className)) {
          final quantity = foodCount[className]!;

          foodInfo.add(FoodInfo(
            foodId: item['food_id'] as String?,
            foodName: foodName ?? 'Unknown',
            calories: (item['calories']?.toDouble() ?? 0.0) * quantity,
            protein: (item['protein']?.toDouble() ?? 0.0) * quantity,
            carb: (item['carbs']?.toDouble() ?? 0.0) * quantity,
            fat: (item['fat']?.toDouble() ?? 0.0) * quantity,
            quantity: quantity,
          ));
          print(
              '✅ Added food item to result list: $foodName (class=$className, quantity: $quantity)');
        } else {
          print(
              '⚠️ Food item skipped, no match found for class_name=$className in foodCount=${foodCount.keys}');
        }
      }

      print('📈 Final food info list size: ${foodInfo.length}');
      return FecthFoodDataSuccess(foodInfoList: foodInfo);
    } catch (e) {
      return FecthFoodDataFalure(
          message: 'Failed to fetch food data. Error: ${e.toString()}',
          error: Exception(e.toString()));
    }
  }

  Future<bool> saveScanResults({
    required List<FoodInfo> foodInfoList,
    required File? imageFile,
    String? note,
  }) async {
    try {
      // Get user ID from RuntimeMemoryStorage
      final sessionData =
          RuntimeMemoryStorage.get<Map<String, dynamic>>('session');
      final userId = sessionData?['uId'] as String?;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final supabase = sl<SupabaseService>().client;
      String? imageUrl;
      String? mealDetectionId;

      // Upload image if provided và lưu meal_detection trước
      if (imageFile != null) {
        try {
          final imageFileName =
              'meal_images/${DateTime.now().millisecondsSinceEpoch}_${path.basename(imageFile.path)}';

          await supabase.storage
              .from('nu-img')
              .upload(
                imageFileName,
                imageFile,
                fileOptions: const FileOptions(
                  cacheControl: '3600',
                ),
              )
              .timeout(const Duration(seconds: 10));

          imageUrl =
              supabase.storage.from('nu-img').getPublicUrl(imageFileName);

          // Lưu meal_detection trước để có thể lấy ID
          if (imageUrl != null) {
            final mealDetectionInsert = await supabase
                .from('meal_detection')
                .insert({
                  'user_id': userId,
                  'image_url': imageUrl,
                  'result': foodInfoList.map((food) => food.toJson()).toList(),
                })
                .select('meal_detection_id')
                .single();

            mealDetectionId = mealDetectionInsert['meal_detection_id'];
          }
        } catch (storageError) {
          print('Storage error: $storageError');
        }
      }

      // Save meal with meal_detection_id (nếu có)
      // Sử dụng thời gian từ máy chủ bằng cách lưu UTC và chỉ định múi giờ rõ ràng
      final mealTime = DateTime.now().toUtc();
      final mealNote = note ?? 'Scanned meal';

      // Tạo meal với meal_detection_id nếu có
      final mealData = {
        'user_id': userId,
        'meal_time': mealTime.toIso8601String(), // Lưu dưới dạng UTC ISO
        'note': mealNote,
      };

      // Thêm meal_detection_id nếu có
      if (mealDetectionId != null) {
        mealData['meal_detection_id'] = mealDetectionId;
      }

      final mealInsert = await supabase
          .from('meal')
          .insert(mealData)
          .select('meal_id')
          .single();

      final mealId = mealInsert['meal_id'] as String;

      // Insert meal items
      final mealItems = foodInfoList
          .map((food) => {
                'meal_id': mealId,
                'food_id': food.foodId,
                'quantity': food.quantity,
              })
          .toList();

      await supabase.from('meal_item').insert(mealItems);

      // Tính tổng dinh dưỡng cho bữa ăn
      double totalCalories = 0;
      double totalProtein = 0;
      double totalFat = 0;
      double totalCarbs = 0;

      for (var food in foodInfoList) {
        totalCalories += food.calories;
        totalProtein += food.protein;
        totalFat += food.fat;
        totalCarbs += food.carb;
      }

      // Cập nhật nutrition_log cho ngày hiện tại - sử dụng múi giờ Việt Nam (+7)
      final vietnamTime = mealTime.add(const Duration(hours: 7));
      final today = DateFormat('yyyy-MM-dd').format(vietnamTime);

      // Kiểm tra xem đã có bản ghi cho ngày hôm nay chưa
      final existingLogResponse = await supabase
          .from('nutrition_log')
          .select(
              'nutrition_log_id, total_calories, total_protein, total_fat, total_carbs')
          .eq('user_id', userId)
          .eq('log_date', today)
          .maybeSingle();

      if (existingLogResponse != null) {
        // Đã có bản ghi cho ngày hôm nay - cập nhật giá trị
        final existingLog = existingLogResponse;
        await supabase.from('nutrition_log').update({
          'total_calories':
              (existingLog['total_calories'] as num).toDouble() + totalCalories,
          'total_protein':
              (existingLog['total_protein'] as num).toDouble() + totalProtein,
          'total_fat': (existingLog['total_fat'] as num).toDouble() + totalFat,
          'total_carbs':
              (existingLog['total_carbs'] as num).toDouble() + totalCarbs,
        }).eq('nutrition_log_id', existingLog['nutrition_log_id']);
      } else {
        // Chưa có bản ghi cho ngày hôm nay - tạo mới
        await supabase.from('nutrition_log').insert({
          'user_id': userId,
          'log_date': today,
          'total_calories': totalCalories,
          'total_protein': totalProtein,
          'total_fat': totalFat,
          'total_carbs': totalCarbs,
        });
      }

      return true;
    } catch (e) {
      print('Error saving scan results: ${e.toString()}');
      return false;
    }
  }
}
