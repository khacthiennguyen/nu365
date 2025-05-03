import 'package:json_annotation/json_annotation.dart';

part '../../../generated/features/scan/models/nutrition.g.dart';

@JsonSerializable()
class Nutrition {
  final int calories;
  final int protein;
  final int carbs;
  final int fat;

  Nutrition({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  factory Nutrition.fromJson(Map<String, dynamic> json) =>
      _$NutritionFromJson(json);

  Map<String, dynamic> toJson() => _$NutritionToJson(this);

  // Default values for 12 specific food items (per typical serving)
  static Map<String, Nutrition> defaultValues = {
    // Fruits
    'apple': Nutrition(calories: 95, protein: 0, carbs: 25, fat: 0), // 1 medium (182g)
    
    // Vietnamese foods
    'banh_mi': Nutrition(calories: 400, protein: 15, carbs: 50, fat: 10), // Typical sandwich
    
    // Fast food
    'donut': Nutrition(calories: 195, protein: 2, carbs: 22, fat: 11), // 1 glazed (52g)
    'french_fries': Nutrition(calories: 365, protein: 4, carbs: 48, fat: 17), // Medium (117g)
    'fried_chicken': Nutrition(calories: 320, protein: 27, carbs: 11, fat: 18), // 1 thigh with skin
    'pizza': Nutrition(calories: 285, protein: 12, carbs: 36, fat: 10), // 1 slice cheese (107g)
    
    // Vietnamese rolls
    'goi_cuon': Nutrition(calories: 91, protein: 5, carbs: 12, fat: 3), // 1 roll (~50g)
    
    // Basic ingredients
    'egg': Nutrition(calories: 78, protein: 6, carbs: 0, fat: 5), // 1 large (50g)
    'milk': Nutrition(calories: 122, protein: 8, carbs: 12, fat: 5), // Whole milk, 1 cup (244g)
    'rice': Nutrition(calories: 206, protein: 4, carbs: 45, fat: 0), // Cooked, 1 cup (158g)
    'shrimp': Nutrition(calories: 84, protein: 20, carbs: 0, fat: 0), // Cooked, 3oz (85g)
    
    // Japanese
    'sushi': Nutrition(calories: 200, protein: 7, carbs: 28, fat: 7), // 1 roll (6 pieces)
  };

  static Nutrition getDefaultForFood(String foodName) {
    final normalizedName = foodName.toLowerCase();
    return defaultValues[normalizedName] ?? 
           Nutrition(calories: 0, protein: 0, carbs: 0, fat: 0); // Return zero values if not found
  }
}