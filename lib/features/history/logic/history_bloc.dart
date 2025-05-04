import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nu365/features/history/logic/history_event.dart';
import 'package:nu365/features/history/logic/history_state.dart';
import 'package:nu365/features/history/services/history_service.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryService _historyService = HistoryService();

  HistoryBloc() : super(const HistoryInitial()) {
    on<LoadHistoryEvent>(_onLoadHistory);
    on<LoadMealDetailEvent>(_onLoadMealDetail);
    on<DeleteMealEvent>(_onDeleteMeal);
    on<RefreshHistoryEvent>(_onRefreshHistory);
  }

  Future<void> _onLoadHistory(
    LoadHistoryEvent event,
    Emitter<HistoryState> emit,
  ) async {
    emit(const HistoryLoading());
    emit(await _historyService.loadHistory());
  }

  Future<void> _onLoadMealDetail(
    LoadMealDetailEvent event,
    Emitter<HistoryState> emit,
  ) async {
    emit(const MealDetailLoading());

    final meal = await _historyService.getMealDetail(event.mealId);

    if (meal != null) {
      emit(MealDetailLoaded(meal: meal));
    } else {
      emit(const MealDetailError(errorMessage: 'Failed to load meal details'));
    }
  }

  Future<void> _onDeleteMeal(
    DeleteMealEvent event,
    Emitter<HistoryState> emit,
  ) async {
    // Keep current state while deleting
    final currentState = state;

    final success = await _historyService.deleteMeal(event.mealId);

    if (success) {
      // Reload history to reflect the deletion
      emit(const HistoryLoading());
      emit(await _historyService.loadHistory());
    } else if (currentState is HistoryLoaded) {
      // Restore previous state if deletion failed
      emit(currentState);
      emit(const HistoryError(errorMessage: 'Failed to delete meal'));
    }
  }

  Future<void> _onRefreshHistory(
    RefreshHistoryEvent event,
    Emitter<HistoryState> emit,
  ) async {
    emit(const HistoryLoading());
    emit(await _historyService.loadHistory());
  }
}
