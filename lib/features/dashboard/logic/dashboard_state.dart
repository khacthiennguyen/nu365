abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoadSuccess extends DashboardState {
  final Map<String, dynamic> todayNutrition;
  final Map<String, List<double>> weeklyNutrition;
  final List<Map<String, dynamic>> recentMeals;

  DashboardLoadSuccess({
    required this.todayNutrition,
    required this.weeklyNutrition,
    required this.recentMeals,
  });
}

class DashboardLoadFailure extends DashboardState {
  final String message;

  DashboardLoadFailure(this.message);
}
