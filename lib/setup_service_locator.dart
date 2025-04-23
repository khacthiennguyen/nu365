import 'package:get_it/get_it.dart';
import 'package:nu365/core/data/objectbox_service.dart';



final GetIt sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerSingleton<ObjectBoxService>(ObjectBoxImpl());
}