import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nu365/features/dashboard/logic/dashboard_event.dart';
import 'package:nu365/features/dashboard/logic/dashboard_state.dart';
import 'package:nu365/features/dashboard/models/dashboard_data.dart';
import 'package:nu365/features/dashboard/services/dashboard_services.dart';
import 'package:nu365/setup_service_locator.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardService _dashboardService = sl<DashboardService>();

  DashboardBloc() : super(DashboardInitial()) {
    on<LoadDashboard>(_onLoadDashboard);
    on<RefreshDashboard>(_onRefreshDashboard);
  }

  Future<void> _onLoadDashboard(
    LoadDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    try {
      final dashboardData = await _dashboardService.loadDashboardData();
      emit(_mapDashboardDataToState(dashboardData));
    } catch (e) {
      emit(DashboardLoadFailure(e.toString()));
    }
  }

  Future<void> _onRefreshDashboard(
    RefreshDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      final dashboardData = await _dashboardService.loadDashboardData();
      emit(_mapDashboardDataToState(dashboardData));
    } catch (e) {
      emit(DashboardLoadFailure(e.toString()));
    }
  }

  DashboardState _mapDashboardDataToState(DashboardData data) {
    // Prepare today's nutrition data for the UI
    final todayNutrition = {
      'calories': data.todayNutrition.calories,
      'protein': data.todayNutrition.protein,
      'fat': data.todayNutrition.fat,
      'carbs': data.todayNutrition.carbs,
      'goals': {
        'calories': data.goals.calories,
        'protein': data.goals.protein,
        'fat': data.goals.fat,
        'carbs': data.goals.carbs,
      },
    };

    // Prepare weekly nutrition data for the UI charts
    final weeklyNutrition = data.weeklyNutrition.data;

    // Prepare recent meals list for the UI
    final recentMeals = data.recentMeals.map((meal) => meal.toJson()).toList();

    return DashboardLoadSuccess(
      todayNutrition: todayNutrition,
      weeklyNutrition: weeklyNutrition,
      recentMeals: recentMeals,
    );
  }
}
