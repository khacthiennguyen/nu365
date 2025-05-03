import 'dart:io';

abstract class ScanEvent {}

class TakeImgEvent extends ScanEvent {
  final File imgfile;
  TakeImgEvent({required this.imgfile});
}

class FetchFoodData extends ScanEvent {
  final List<String> foodLists;
  FetchFoodData({required this.foodLists});
}
