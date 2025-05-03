import 'dart:io';

import 'package:nu365/features/scan/models/prediction.dart';
import 'package:nu365/features/scan/models/scan_result.dart';

abstract class ScanState {}

class ScanStateInitial extends ScanState {}

class ScanLoading extends ScanState {}

class ScanSuccess extends ScanState {
  final File imageFile;
  final List<Prediction> predictions;
  ScanSuccess({required this.predictions, required this.imageFile});
}

class FecthFoodDataSuccess extends ScanState {
  final List<FoodInfo> foodInfoList;
  FecthFoodDataSuccess({required this.foodInfoList});
}

class ScanFailure extends ScanState {
  final String? message;
  final Exception? error;
  ScanFailure({required this.message, required this.error});
}

class FecthFoodDataFalure extends ScanState {
  final String? message;
  final Exception? error;
  FecthFoodDataFalure({required this.message, required this.error});
}
