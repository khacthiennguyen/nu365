import 'package:nu365/core/data/supabase/supabase_service.dart';
import 'package:nu365/features/scan/logic/scan_state.dart';
import 'package:nu365/features/scan/models/scan_result.dart';
import 'package:nu365/setup_service_locator.dart';

class ResultScanService {
  Future<ScanState> fetchFoodData(List<String> foodLists) async {
    try {
      // Đếm số lượng mỗi loại thực phẩm
      Map<String, int> foodCount = {};
      for (var food in foodLists) {
        if (foodCount.containsKey(food)) {
          foodCount[food] = foodCount[food]! + 1;
        } else {
          foodCount[food] = 1;
        }
      }
      // Danh sách loại thực phẩm duy nhất để query
      final uniqueFoodList = foodCount.keys.toList();

      final response = await sl<SupabaseService>()
          .client
          .from('food')
          .select('name,fat,carbs,protein,calories,class_name')
          .or(uniqueFoodList.map((f) => 'class_name.eq.$f').join(','));

      List<FoodInfo> foodInfo = [];

      for (var item in response as List) {
        final className = item['class_name'] as String?;
        if (className != null && foodCount.containsKey(className)) {
          final quantity = foodCount[className] ?? 1;

          foodInfo.add(FoodInfo(
            foodName: item['name'] ?? 'Unknown',
            calories: (item['calories']?.toDouble() ?? 0.0),
            protein: (item['protein']?.toDouble() ?? 0.0),
            carb: (item['carbs']?.toDouble() ?? 0.0),
            fat: (item['fat']?.toDouble() ?? 0.0),
            quantity: quantity,
          ));
        }
      }

      return FecthFoodDataSuccess(foodInfoList: foodInfo);
    } catch (e) {
      return FecthFoodDataFalure(
          message: 'Không lấy thông tin thức ăn được. Lỗi: ${e.toString()}',
          error: Exception(e.toString()));
    }
  }


  
}
