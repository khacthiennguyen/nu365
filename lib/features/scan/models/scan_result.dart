import 'package:json_annotation/json_annotation.dart';

part '../../../generated/features/scan/models/scan_result.g.dart';

@JsonSerializable()
class FoodInfo {
  final String foodName;
  final double calories;
  final double protein;
  final double carb;
  final double fat;
  final int quantity; // Thêm số lượng

  FoodInfo({
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.carb,
    required this.fat,
    this.quantity = 1, // Mặc định là 1
  });

  factory FoodInfo.fromJson(Map<String, dynamic> json) =>
      _$FoodInfoFromJson(json);

  Map<String, dynamic> toJson() => _$FoodInfoToJson(this);

  // Tạo bản sao với số lượng mới
  FoodInfo copyWithQuantity(int newQuantity) {
    return FoodInfo(
      foodName: foodName,
      calories: calories,
      protein: protein,
      carb: carb,
      fat: fat,
      quantity: newQuantity,
    );
  }
}
