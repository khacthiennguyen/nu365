import 'dart:io';

abstract class ScanEvent {}

class TakeImgEvent extends ScanEvent {
  final File imgfile;
  TakeImgEvent({required this.imgfile});
}
