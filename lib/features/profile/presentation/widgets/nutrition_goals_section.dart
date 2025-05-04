import 'package:flutter/material.dart';
import 'package:nu365/core/constants/app_theme.dart';

class NutritionGoalsSection extends StatelessWidget {
  final double? goalCalories;
  final double? goalProtein;
  final double? goalFat;
  final double? goalCarbs;
  final bool isEditMode;
  final TextEditingController caloriesController;
  final TextEditingController proteinController;
  final TextEditingController fatController;
  final TextEditingController carbsController;

  const NutritionGoalsSection({
    super.key,
    this.goalCalories,
    this.goalProtein,
    this.goalFat,
    this.goalCarbs,
    required this.isEditMode,
    required this.caloriesController,
    required this.proteinController,
    required this.fatController,
    required this.carbsController,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mục tiêu dinh dưỡng',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryPurple,
                  ),
                ),
                Icon(
                  Icons.fitness_center,
                  color: AppTheme.primaryPurple,
                ),
              ],
            ),
            const Divider(height: 24),
            _buildGoalField(
              icon: Icons.local_fire_department,
              title: 'Calories',
              value: goalCalories,
              unit: 'kcal',
              color: Colors.orange,
              controller: caloriesController,
            ),
            const SizedBox(height: 12),
            _buildGoalField(
              icon: Icons.egg_alt_outlined,
              title: 'Protein',
              value: goalProtein,
              unit: 'g',
              color: Colors.red,
              controller: proteinController,
            ),
            const SizedBox(height: 12),
            _buildGoalField(
              icon: Icons.water_drop_outlined,
              title: 'Fat',
              value: goalFat,
              unit: 'g',
              color: Colors.blue,
              controller: fatController,
            ),
            const SizedBox(height: 12),
            _buildGoalField(
              icon: Icons.grain,
              title: 'Carbs',
              value: goalCarbs,
              unit: 'g',
              color: Colors.green,
              controller: carbsController,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalField({
    required IconData icon,
    required String title,
    required double? value,
    required String unit,
    required Color color,
    required TextEditingController controller,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              isEditMode
                  ? TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Nhập $title',
                        suffixText: unit,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    )
                  : Text(
                      value != null ? '$value $unit' : 'Chưa thiết lập',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
