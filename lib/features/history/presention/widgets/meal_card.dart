import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nu365/features/history/models/meal.dart';
import 'package:nu365/features/history/presention/widgets/nutrient_info.dart';

class MealCard extends StatelessWidget {
  final MealModel meal;
  final VoidCallback onTap;

  const MealCard({
    super.key,
    required this.meal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Format time - Chuyển đổi từ UTC sang múi giờ địa phương
    final localDateTime = meal.meal_time.toLocal();
    final timeStr = DateFormat('h:mm a').format(localDateTime);

    // Calculate total calories
    final totalCalories = meal.calculatedTotalCalories.toInt();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image or placeholder
              if (meal.image_url != null && meal.image_url!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    meal.image_url!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[300],
                        child: const Icon(Icons.no_food, color: Colors.grey),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                  ),
                )
              else
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.restaurant, color: Colors.grey),
                ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          timeStr,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '$totalCalories kcal',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      meal.note ?? 'No description',
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Hiển thị thông tin protein, carbs, fat với màu sắc
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        NutrientInfo(
                          label: 'Protein',
                          value:
                              '${meal.calculatedTotalProtein.toStringAsFixed(1)}g',
                          color: Colors.blue.shade700,
                        ),
                        NutrientInfo(
                          label: 'Carbs',
                          value:
                              '${meal.calculatedTotalCarb.toStringAsFixed(1)}g',
                          color: Colors.amber.shade800,
                        ),
                        NutrientInfo(
                          label: 'Fat',
                          value:
                              '${meal.calculatedTotalFat.toStringAsFixed(1)}g',
                          color: Colors.purple.shade600,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
