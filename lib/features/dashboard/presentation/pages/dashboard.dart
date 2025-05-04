import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nu365/features/dashboard/logic/dashboard_bloc.dart';
import 'package:nu365/features/dashboard/logic/dashboard_event.dart';
import 'package:nu365/features/dashboard/logic/dashboard_state.dart';
import 'package:nu365/features/dashboard/presentation/widgets/dashboard_error_widget.dart';
import 'package:nu365/features/dashboard/presentation/widgets/nutrition_chart.dart';
import 'package:nu365/features/dashboard/presentation/widgets/nutrition_summary.dart';
import 'package:nu365/features/dashboard/presentation/widgets/recent_meals.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc()..add(LoadDashboard()),
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardInitial || state is DashboardLoading) {
            return const _DashboardLoading();
          } else if (state is DashboardLoadSuccess) {
            return _DashboardContent(
              todayNutrition: state.todayNutrition,
              weeklyNutrition: state.weeklyNutrition,
              recentMeals: state.recentMeals,
            );
          } else if (state is DashboardLoadFailure) {
            return DashboardErrorWidget(message: state.message);
          } else {
            return const DashboardErrorWidget(
                message: 'Trạng thái không xác định');
          }
        },
      ),
    );
  }
}

class _DashboardLoading extends StatelessWidget {
  const _DashboardLoading();

  @override
  Widget build(BuildContext context) {
    // Thay thế CircularProgressIndicator bằng Skeletonizer
    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Skeleton cho Nutrition Summary
            Card(
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
                    _buildNutrientProgressBarSkeleton(
                      context,
                      'Calories',
                      '0',
                      '2000',
                    ),
                    const SizedBox(height: 16.0),
                    _buildNutrientProgressBarSkeleton(
                      context,
                      'Protein',
                      '0g',
                      '100g',
                    ),
                    const SizedBox(height: 16.0),
                    _buildNutrientProgressBarSkeleton(
                      context,
                      'Chất béo',
                      '0g',
                      '80g',
                    ),
                    const SizedBox(height: 16.0),
                    _buildNutrientProgressBarSkeleton(
                      context,
                      'Carbs',
                      '0g',
                      '200g',
                    ),
                  ],
                ),
              ),
            ),

            // Skeleton cho Nutrition Chart
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
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
                      'Biểu đồ dinh dưỡng tuần này',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16.0),
                    Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ),
            ),

            // Skeleton cho Recent Meals
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bữa ăn gần đây',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8.0),
                  ...List.generate(
                    3,
                    (index) => Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        title: Text('Bữa ăn $index'),
                        subtitle: const Text('Đang tải dữ liệu...'),
                        trailing: const Text('0 kcal'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientProgressBarSkeleton(
    BuildContext context,
    String label,
    String current,
    String goal,
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
          value: 0.5,
          backgroundColor: Colors.grey.shade200,
          color: Colors.grey.shade400,
          minHeight: 10.0,
          borderRadius: BorderRadius.circular(5.0),
        ),
      ],
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final Map<String, dynamic> todayNutrition;
  final Map<String, List<double>> weeklyNutrition;
  final List<Map<String, dynamic>> recentMeals;

  const _DashboardContent({
    required this.todayNutrition,
    required this.weeklyNutrition,
    required this.recentMeals,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<DashboardBloc>().add(RefreshDashboard());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NutritionSummary(
              todayNutrition: todayNutrition,
            ),
            const SizedBox(height: 16),
            NutritionChart(
              weeklyNutrition: weeklyNutrition,
            ),
            const SizedBox(height: 16),
            RecentMeals(
              recentMeals: recentMeals,
            ),
            const SizedBox(height: 32), // Extra space at the bottom
          ],
        ),
      ),
    );
  }
}
