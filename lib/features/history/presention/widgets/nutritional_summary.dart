import 'package:flutter/material.dart';
import 'package:nu365/features/history/models/meal.dart';

class NutritionalSummary extends StatelessWidget {
  final MealModel meal;

  const NutritionalSummary({
    super.key,
    required this.meal,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nutritional Summary',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _nutritionInfoItem(
                    context,
                    'Calories',
                    '${meal.calculatedTotalCalories.toInt()} kcal',
                    Colors.red[400]!),
                _nutritionInfoItem(
                    context,
                    'Protein',
                    '${meal.calculatedTotalProtein.toStringAsFixed(1)} g',
                    Colors.blue[400]!),
                _nutritionInfoItem(
                    context,
                    'Carbs',
                    '${meal.calculatedTotalCarb.toStringAsFixed(1)} g',
                    Colors.amber[700]!),
                _nutritionInfoItem(
                    context,
                    'Fat',
                    '${meal.calculatedTotalFat.toStringAsFixed(1)} g',
                    Colors.purple[400]!),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _nutritionInfoItem(
      BuildContext context, String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              label[0],
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
