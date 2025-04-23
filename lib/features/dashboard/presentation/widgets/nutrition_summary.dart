import 'package:flutter/material.dart';
import 'package:nu365/core/constants/app_theme.dart';

class NutritionSummary extends StatelessWidget {
  const NutritionSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Today's Nutrition",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildNutrientCard(
                  label: 'Calories',
                  value: '1,450',
                  total: '2,000',
                  unit: 'kcal',
                  progress: 0.72,
                  color: AppTheme.primaryGreen,
                ),
                _buildNutrientCard(
                  label: 'Protein',
                  value: '65',
                  total: '90',
                  unit: 'g',
                  progress: 0.72,
                  color: AppTheme.primaryPurple,
                ),
                _buildNutrientCard(
                  label: 'Carbs',
                  value: '180',
                  total: '250',
                  unit: 'g',
                  progress: 0.72,
                  color: const Color(0xFFF97316), // Orange
                ),
                _buildNutrientCard(
                  label: 'Fat',
                  value: '45',
                  total: '65',
                  unit: 'g',
                  progress: 0.69,
                  color: const Color(0xFF3B82F6), // Blue
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientCard({
    required String label,
    required String value,
    required String total,
    required String unit,
    required double progress,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              ' / $total $unit',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
