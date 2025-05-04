import 'package:json_annotation/json_annotation.dart';
import 'package:nu365/features/history/models/food_item.dart';
part '../../../generated/features/history/models/meal.g.dart';

@JsonSerializable(explicitToJson: true)
class MealModel {
  final String meal_id;
  final DateTime meal_time;
  final String? note;
  final String? image_url;
  final List<FoodItem>? food_items;

  // Nutritional summary
  final double? total_calories;
  final double? total_protein;
  final double? total_fat;
  final double? total_carb;

  MealModel({
    required this.meal_id,
    required this.meal_time,
    this.note,
    this.image_url,
    this.food_items,
    this.total_calories,
    this.total_protein,
    this.total_fat,
    this.total_carb,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) =>
      _$MealModelFromJson(json);
  Map<String, dynamic> toJson() => _$MealModelToJson(this);

  // Get formatted date (e.g., "May 4, 2023")
  String get formattedDate {
    return '${_getMonthName(meal_time.month)} ${meal_time.day}, ${meal_time.year}';
  }

  // Get formatted time (e.g., "3:30 PM")
  String get formattedTime {
    final hour = meal_time.hour > 12 ? meal_time.hour - 12 : meal_time.hour;
    final hourDisplay = hour == 0 ? 12 : hour;
    final minute = meal_time.minute.toString().padLeft(2, '0');
    final period = meal_time.hour >= 12 ? 'PM' : 'AM';
    return '$hourDisplay:$minute $period';
  }

  // Helper method to get month name
  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  // Calculate total nutrition from food items
  double get calculatedTotalCalories =>
      food_items?.fold(0, (sum, item) => sum! + item.totalCalories) ??
      total_calories ??
      0;

  double get calculatedTotalProtein =>
      food_items?.fold(0, (sum, item) => sum! + item.totalProtein) ??
      total_protein ??
      0;

  double get calculatedTotalFat =>
      food_items?.fold(0, (sum, item) => sum! + item.totalFat) ??
      total_fat ??
      0;

  double get calculatedTotalCarb =>
      food_items?.fold(0, (sum, item) => sum! + item.totalCarb) ??
      total_carb ??
      0;
}
