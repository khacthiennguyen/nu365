import 'package:flutter/material.dart';
import 'package:nu365/features/history/models/food_item.dart';

class FoodItemCard extends StatelessWidget {
  final FoodItem food;

  const FoodItemCard({
    Key? key,
    required this.food,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    food.foodName,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${food.quantity} ${food.quantity > 1 ? 'servings' : 'serving'}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _foodNutrientInfo(
                    context, 'Calories', '${food.totalCalories.toInt()} kcal'),
                _foodNutrientInfo(context, 'Protein',
                    '${food.totalProtein.toStringAsFixed(1)} g'),
                _foodNutrientInfo(
                    context, 'Carbs', '${food.totalCarb.toStringAsFixed(1)} g'),
                _foodNutrientInfo(
                    context, 'Fat', '${food.totalFat.toStringAsFixed(1)} g'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _foodNutrientInfo(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}
