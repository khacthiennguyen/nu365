import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NutritionSummary extends StatelessWidget {
  final Map<String, dynamic> todayNutrition;

  const NutritionSummary({
    Key? key,
    required this.todayNutrition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get nutrition values and goals
    final calories = todayNutrition['calories'] as double? ?? 0.0;
    final protein = todayNutrition['protein'] as double? ?? 0.0;
    final fat = todayNutrition['fat'] as double? ?? 0.0;
    final carbs = todayNutrition['carbs'] as double? ?? 0.0;

    final goals = todayNutrition['goals'] as Map<String, dynamic>? ??
        {
          'calories': 0.0,
          'protein': 0.0,
          'fat': 0.0,
          'carbs': 0.0,
        };

    final caloriesGoal = goals['calories'] as double? ?? 0.0;
    final proteinGoal = goals['protein'] as double? ?? 0.0;
    final fatGoal = goals['fat'] as double? ?? 0.0;
    final carbsGoal = goals['carbs'] as double? ?? 0.0;

    final bool goalsNotSet =
        caloriesGoal <= 0 || proteinGoal <= 0 || fatGoal <= 0 || carbsGoal <= 0;

    // Nếu người dùng chưa thiết lập mục tiêu, hiển thị thông báo
    if (goalsNotSet) {
      return Card(
        margin: const EdgeInsets.all(16.0),
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Dinh dưỡng hôm nay',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24.0),
              Icon(
                Icons.settings,
                size: 60,
                color: Colors.grey.shade500,
              ),
              const SizedBox(height: 16.0),
              Text(
                'Bạn chưa thiết lập mục tiêu dinh dưỡng',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8.0),
              Text(
                'Hãy vào cài đặt để thiết lập mục tiêu dinh dưỡng',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton.icon(
                onPressed: () {
                  // Điều hướng đến trang thiết lập mục tiêu
                  context.go('/personal-info');
                },
                icon: const Icon(Icons.settings),
                label: const Text('Vào cài đặt'),
              ),
            ],
          ),
        ),
      );
    }

    // Calculate progress percentages
    final caloriesProgress =
        caloriesGoal > 0 ? (calories / caloriesGoal).clamp(0.0, 1.0) : 0.0;
    final proteinProgress =
        proteinGoal > 0 ? (protein / proteinGoal).clamp(0.0, 1.0) : 0.0;
    final fatProgress = fatGoal > 0 ? (fat / fatGoal).clamp(0.0, 1.0) : 0.0;
    final carbsProgress =
        carbsGoal > 0 ? (carbs / carbsGoal).clamp(0.0, 1.0) : 0.0;

    // Hiển thị bảng dinh dưỡng như bình thường nếu đã có mục tiêu
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dinh dưỡng hôm nay',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24.0),
            _buildNutrientProgressBar(
              context,
              'Calories',
              calories.round().toString(),
              caloriesGoal.round().toString(),
              caloriesProgress,
              Colors.red.shade400,
            ),
            const SizedBox(height: 16.0),
            _buildNutrientProgressBar(
              context,
              'Protein',
              '${protein.round()}g',
              '${proteinGoal.round()}g',
              proteinProgress,
              Colors.blue.shade400,
            ),
            const SizedBox(height: 16.0),
            _buildNutrientProgressBar(
              context,
              'Chất béo',
              '${fat.round()}g',
              '${fatGoal.round()}g',
              fatProgress,
              Colors.amber.shade400,
            ),
            const SizedBox(height: 16.0),
            _buildNutrientProgressBar(
              context,
              'Carbs',
              '${carbs.round()}g',
              '${carbsGoal.round()}g',
              carbsProgress,
              Colors.green.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientProgressBar(
    BuildContext context,
    String label,
    String current,
    String goal,
    double progress,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              '$current / $goal',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.shade200,
          color: color,
          minHeight: 10.0,
          borderRadius: BorderRadius.circular(5.0),
        ),
      ],
    );
  }
}
