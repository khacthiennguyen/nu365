import 'package:equatable/equatable.dart';
import 'package:nu365/features/history/models/meal.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {
  const HistoryInitial();
}

class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

class HistoryLoaded extends HistoryState {
  final List<MealModel> meals;

  const HistoryLoaded({required this.meals});

  @override
  List<Object?> get props => [meals];
}

class HistoryError extends HistoryState {
  final String errorMessage;

  const HistoryError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class MealDetailLoading extends HistoryState {
  const MealDetailLoading();
}

class MealDetailLoaded extends HistoryState {
  final MealModel meal;

  const MealDetailLoaded({required this.meal});

  @override
  List<Object?> get props => [meal];
}

class MealDetailError extends HistoryState {
  final String errorMessage;

  const MealDetailError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
