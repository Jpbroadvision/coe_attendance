import 'package:get_it/get_it.dart';

import 'src/core/service/database_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => DatabaseService());
}
