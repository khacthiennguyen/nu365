import 'package:get_it/get_it.dart';
import 'package:nu365/core/data/supabase/supabase_service.dart';


final GetIt sl = GetIt.instance;

void setupServiceLocator() {
  // Register your services here
  // Example: sl.registerLazySingleton<SomeService>(() => SomeService()); 

  sl.registerLazySingleton<SupabaseService>(() => SupabaseService());
 
}