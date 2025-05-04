import 'package:json_annotation/json_annotation.dart';
part '../../../generated/features/history/models/food_item.g.dart';

@JsonSerializable()
class FoodItem {
  final String? food_id; // Thêm trường food_id
  final String foodName;
  final double calories;
  final double protein;
  final double fat;
  final double carb;
  final int quantity;

  FoodItem({
    this.food_id, // Khởi tạo food_id
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carb,
    this.quantity = 1,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) =>
      _$FoodItemFromJson(json);
  Map<String, dynamic> toJson() => _$FoodItemToJson(this);

  // Calculate total nutritional values based on quantity
  double get totalCalories => calories * quantity;
  double get totalProtein => protein * quantity;
  double get totalFat => fat * quantity;
  double get totalCarb => carb * quantity;
}
