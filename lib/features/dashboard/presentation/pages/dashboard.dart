import 'package:flutter/material.dart';
import 'package:nu365/features/dashboard/presentation/widgets/nutrition_chart.dart';
import 'package:nu365/features/dashboard/presentation/widgets/nutrition_summary.dart';
import 'package:nu365/features/dashboard/presentation/widgets/recent_meals.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NutritionSummary(),
          SizedBox(height: 16),
          NutritionChart(),
          SizedBox(height: 16),
          RecentMeals(),
        ],
      ),
    );
  }
}
