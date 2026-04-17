import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../api/api_client.dart';
import '../api/interceptors/auth_interceptor.dart';
import '../api/interceptors/logging_interceptor.dart';

void setupCoreDependencies(GetIt sl) {
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  sl.registerLazySingleton<LoggingInterceptor>(() => LoggingInterceptor());

  sl.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(sl<FlutterSecureStorage>()),
  );

  sl.registerLazySingleton<Dio>(() {
    final dio = Dio();
    dio.interceptors.addAll([
      sl<LoggingInterceptor>(),
      sl<AuthInterceptor>(),
    ]);
    return dio;
  });

  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl<Dio>()));
}
