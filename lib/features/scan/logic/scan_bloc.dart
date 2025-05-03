import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nu365/features/scan/logic/scan_event.dart';
import 'package:nu365/features/scan/logic/scan_state.dart';
import 'package:nu365/features/scan/services/scan_service.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  ScanBloc() : super(ScanStateInitial()) {
    on<TakeImgEvent>((event, emit) async {
      emit(ScanLoading());
      // Call scanning service and emit result
      final result = await ScanService.scanImage(event.imgfile);
      emit(result);
    });
  }
}
