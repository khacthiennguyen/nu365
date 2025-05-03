import 'package:flutter/material.dart';
import 'package:nu365/features/scan/models/scan_result.dart';
import 'package:nu365/core/constants/app_theme.dart';

class NutritionTabContent extends StatelessWidget {
  final List<FoodInfo> nutrition;

  const NutritionTabContent({
    super.key,
    required this.nutrition,
  });

  @override
  Widget build(BuildContext context) {
    // Tính tổng giá trị dinh dưỡng từ tất cả các thực phẩm với số lượng
    final double totalProtein =
        nutrition.fold(0, (sum, item) => sum + item.protein * item.quantity);
    final double totalCalories =
        nutrition.fold(0, (sum, item) => sum + item.calories * item.quantity);
    final double totalCarb =
        nutrition.fold(0, (sum, item) => sum + item.carb * item.quantity);
    final double totalFat =
        nutrition.fold(0, (sum, item) => sum + item.fat * item.quantity);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Tổng giá trị dinh dưỡng',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Tổng giá trị dinh dưỡng trong 1 hàng (thay vì 2 hàng 2 cột)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCompactNutrientInfo(
                    'Calories', totalCalories.toStringAsFixed(1), 'kcal'),
                _buildDivider(),
                _buildCompactNutrientInfo(
                    'Protein', totalProtein.toStringAsFixed(1), 'g'),
                _buildDivider(),
                _buildCompactNutrientInfo(
                    'Carbs', totalCarb.toStringAsFixed(1), 'g'),
                _buildDivider(),
                _buildCompactNutrientInfo(
                    'Fat', totalFat.toStringAsFixed(1), 'g'),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Danh sách thông tin chi tiết từng thực phẩm
          Text(
            'Chi tiết thực phẩm',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          // Hiển thị danh sách thực phẩm
          ...nutrition.map((food) => _buildFoodItem(food)).toList(),
        ],
      ),
    );
  }

  // Widget hiển thị thông tin dinh dưỡng nhỏ gọn trên 1 hàng
  Widget _buildCompactNutrientInfo(String label, String value, String unit) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryPurple,
          ),
        ),
        Text(
          unit,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey.withOpacity(0.3),
    );
  }

  Widget _buildFoodItem(FoodInfo food) {
    // Tính toán giá trị dinh dưỡng theo số lượng
    final totalCalories = food.calories * food.quantity;
    final totalProtein = food.protein * food.quantity;
    final totalCarb = food.carb * food.quantity;
    final totalFat = food.fat * food.quantity;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tên thực phẩm và số lượng
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  food.foodName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppTheme.primaryPurple,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  'x${food.quantity}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppTheme.primaryPurple,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Thông tin dinh dưỡng một đơn vị
          Text(
            '1 đơn vị:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              _buildNutrientInfo(
                  'Calories', '${food.calories.toStringAsFixed(1)} kcal'),
              _buildNutrientInfo(
                  'Protein', '${food.protein.toStringAsFixed(1)} g'),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              _buildNutrientInfo('Carbs', '${food.carb.toStringAsFixed(1)} g'),
              _buildNutrientInfo('Fat', '${food.fat.toStringAsFixed(1)} g'),
            ],
          ),

          // Giá trị dinh dưỡng tổng theo số lượng
          if (food.quantity > 1) ...[
            const SizedBox(height: 10),
            Text(
              'Tổng (x${food.quantity}):',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildNutrientInfo(
                    'Calories', '${totalCalories.toStringAsFixed(1)} kcal',
                    isTotal: true),
                _buildNutrientInfo(
                    'Protein', '${totalProtein.toStringAsFixed(1)} g',
                    isTotal: true),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildNutrientInfo('Carbs', '${totalCarb.toStringAsFixed(1)} g',
                    isTotal: true),
                _buildNutrientInfo('Fat', '${totalFat.toStringAsFixed(1)} g',
                    isTotal: true),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNutrientInfo(String label, String value,
      {bool isTotal = false}) {
    return Expanded(
      child: Row(
        children: [
          const SizedBox(width: 4),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isTotal ? AppTheme.primaryPurple : null,
            ),
          ),
        ],
      ),
    );
  }
}
