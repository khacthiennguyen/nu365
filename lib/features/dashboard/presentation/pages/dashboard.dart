import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nu365/features/dashboard/logic/dashboard_bloc.dart';
import 'package:nu365/features/dashboard/logic/dashboard_event.dart';
import 'package:nu365/features/dashboard/logic/dashboard_state.dart';
import 'package:nu365/features/dashboard/presentation/widgets/dashboard_error_widget.dart';
import 'package:nu365/features/dashboard/presentation/widgets/nutrition_chart.dart';
import 'package:nu365/features/dashboard/presentation/widgets/nutrition_summary.dart';
import 'package:nu365/features/dashboard/presentation/widgets/recent_meals.dart';

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
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Đang tải dữ liệu...'),
        ],
      ),
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
