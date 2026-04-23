import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../api/api_client.dart';
import '../services/services.dart';

void setupCoreDependencies(GetIt sl) {
  sl.registerLazySingleton<StorageService>(
    () => StorageServiceImpl(const FlutterSecureStorage()),
  );

  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(sl<StorageService>()),
  );
}
