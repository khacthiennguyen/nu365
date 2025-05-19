import 'package:get_it/get_it.dart';
import 'package:nu365/core/data/supabase/supabase_service.dart';
import 'package:nu365/features/dashboard/services/dashboard_services.dart';
import 'package:nu365/features/history/services/history_service.dart';
import 'package:nu365/features/profile/services/settings_services.dart';
import 'package:nu365/features/scan/services/result_scan_service.dart';
import 'package:nu365/features/security/services/biometric_services.dart';
import 'package:nu365/features/security/utils/device_info.dart';

final GetIt sl = GetIt.instance;

void setupServiceLocator() {
  // Register your services here
  // Example: sl.registerLazySingleton<SomeService>(() => SomeService());

  sl.registerLazySingleton<SupabaseService>(() => SupabaseService());
  sl.registerLazySingleton<ResultScanService>(() => ResultScanService());
  sl.registerLazySingleton<HistoryService>(() => HistoryService());
  sl.registerLazySingleton<SettingsServices>(() => SettingsServices());
  sl.registerLazySingleton<DashboardService>(() => DashboardService());
  sl.registerLazySingleton<DeviceInfoService>(() => DeviceInfoService());
  sl.registerLazySingleton<BiometricServices>(() => BiometricServices());
}
