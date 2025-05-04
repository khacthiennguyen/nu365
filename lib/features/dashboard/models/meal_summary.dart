class MealSummary {
  final String mealId;
  final DateTime mealTime;
  final String? imageUrl;
  final String? note;
  final double totalCalories;
  final double totalProtein;
  final double totalFat;
  final double totalCarb;
  final int foodItemCount;

  MealSummary({
    required this.mealId,
    required this.mealTime,
    this.imageUrl,
    this.note,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalFat,
    required this.totalCarb,
    required this.foodItemCount,
  });

  Map<String, dynamic> toJson() {
    return {
      'meal_id': mealId,
      'meal_time': mealTime.toIso8601String(),
      'image_url': imageUrl,
      'note': note,
      'total_calories': totalCalories,
      'total_protein': totalProtein,
      'total_fat': totalFat,
      'total_carb': totalCarb,
      'food_item_count': foodItemCount,
    };
  }

  factory MealSummary.fromJson(Map<String, dynamic> json) {
    return MealSummary(
      mealId: json['meal_id'],
      mealTime: DateTime.parse(json['meal_time']),
      imageUrl: json['image_url'],
      note: json['note'],
      totalCalories: (json['total_calories'] as num?)?.toDouble() ?? 0,
      totalProtein: (json['total_protein'] as num?)?.toDouble() ?? 0,
      totalFat: (json['total_fat'] as num?)?.toDouble() ?? 0,
      totalCarb: (json['total_carb'] as num?)?.toDouble() ?? 0,
      foodItemCount: (json['food_items'] as List?)?.length ?? 0,
    );
  }
}
