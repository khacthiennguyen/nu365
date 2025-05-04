import 'package:equatable/equatable.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadHistoryEvent extends HistoryEvent {
  const LoadHistoryEvent();
}

class LoadMealDetailEvent extends HistoryEvent {
  final String mealId;

  const LoadMealDetailEvent({required this.mealId});

  @override
  List<Object?> get props => [mealId];
}

class DeleteMealEvent extends HistoryEvent {
  final String mealId;

  const DeleteMealEvent({required this.mealId});

  @override
  List<Object?> get props => [mealId];
}

class RefreshHistoryEvent extends HistoryEvent {
  const RefreshHistoryEvent();
}
