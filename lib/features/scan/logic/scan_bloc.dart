import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nu365/features/scan/logic/scan_event.dart';
import 'package:nu365/features/scan/logic/scan_state.dart';
import 'package:nu365/features/scan/services/result_scan_service.dart';
import 'package:nu365/features/scan/services/scan_service.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  ScanBloc() : super(ScanStateInitial()) {
    on<TakeImgEvent>((event, emit) async {
      emit(ScanLoading());
      final result = await ScanService.scanImage(event.imgfile);
      emit(result);
      // Nếu kết quả là ScanSuccess
      if (result is ScanSuccess) {
        final List<String> foodNames =
            result.predictions.map((p) => p.className).toList();

        // Chỉ gọi FetchFoodData nếu có dự đoán hợp lệ
        if (foodNames.isNotEmpty) {
          add(FetchFoodData(foodLists: foodNames));
        } else {
          emit(FecthFoodDataFalure(
            message: 'Không phát hiện thực phẩm trong ảnh',
            error: Exception('No food detected'),
          ));
        }
      }
    });

    on<FetchFoodData>((event, emit) async {
      emit(ScanLoading());
      final resultScanService = ResultScanService();
      try {
        final result = await resultScanService.fetchFoodData(event.foodLists);

        // Ghi log thông tin debug
        if (result is FecthFoodDataSuccess) {
          print("Fetched ${result.foodInfoList.length} food items");
          for (var food in result.foodInfoList) {
            print("Food: ${food.foodName}, Calories: ${food.calories}");
          }
        }

        emit(result);
      } catch (e) {
        print("Error fetching food data: $e");
        emit(FecthFoodDataFalure(
          message: 'Lỗi khi tìm thông tin thực phẩm: ${e.toString()}',
          error: Exception(e.toString()),
        ));
      }
    });
  }
}
