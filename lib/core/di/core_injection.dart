import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../api/api_client.dart';
import '../api/dio_config.dart';
import '../api/interceptors/auth_interceptor.dart';
import '../api/interceptors/logging_interceptor.dart';
import '../services/services.dart';

void setupCoreDependencies(GetIt sl) {
  sl.registerLazySingleton<StorageService>(
    () => StorageServiceImpl(const FlutterSecureStorage()),
  );

  sl.registerLazySingleton<LoggingInterceptor>(() => LoggingInterceptor());

  sl.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(sl<StorageService>()),
  );

  sl.registerLazySingleton<DioConfig>(
    () => DioConfig(
      loggingInterceptor: sl<LoggingInterceptor>(),
      authInterceptor: sl<AuthInterceptor>(),
    ),
  );

  sl.registerLazySingleton<Dio>(() => sl<DioConfig>().dio);

  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl<Dio>()));
}
