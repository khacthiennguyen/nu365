import 'package:get_it/get_it.dart';
import 'package:nu365/core/data/supabase/supabase_service.dart';
import 'package:nu365/features/history/services/history_service.dart';
import 'package:nu365/features/scan/services/result_scan_service.dart';

final GetIt sl = GetIt.instance;

void setupServiceLocator() {
  // Register your services here
  // Example: sl.registerLazySingleton<SomeService>(() => SomeService());

  sl.registerLazySingleton<SupabaseService>(() => SupabaseService());
  sl.registerLazySingleton<ResultScanService>(() => ResultScanService());
  sl.registerLazySingleton<HistoryService>(() => HistoryService());
}
