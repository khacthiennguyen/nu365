import 'dart:io';

import 'package:nu365/features/scan/models/prediction.dart';

abstract class ScanState {}

class ScanStateInitial extends ScanState {}

class ScanLoading extends ScanState {}


class ScanSuccess extends ScanState {
  final File imageFile;
  final List<Prediction> prediction;
  ScanSuccess( {required this.prediction, required this.imageFile});
}

class ScanFailure extends ScanState {
  final String? message;
  final Exception? error;
  ScanFailure({required this.message, required this.error});
}

