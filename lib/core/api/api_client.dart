import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../error/api_response.dart';
import '../services/services.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

class ApiClient {
  ApiClient(StorageService storage) : _dio = _buildDio(storage);

  final Dio _dio;

  static Dio _buildDio(StorageService storage) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: const {'Content-Type': 'application/json', 'Accept': 'application/json'},
      ),
    );
    dio.interceptors.addAll([LoggingInterceptor(), AuthInterceptor(storage)]);
    return dio;
  }

  Future<ApiResponse<Response<dynamic>>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return ApiSuccess(response);
    } on DioException catch (e) {
      return _mapDioException(e);
    }
  }

  Future<ApiResponse<Response<dynamic>>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return ApiSuccess(response);
    } on DioException catch (e) {
      return _mapDioException(e);
    }
  }

  Future<ApiResponse<Response<dynamic>>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return ApiSuccess(response);
    } on DioException catch (e) {
      return _mapDioException(e);
    }
  }

  Future<ApiResponse<Response<dynamic>>> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return ApiSuccess(response);
    } on DioException catch (e) {
      return _mapDioException(e);
    }
  }

  ApiError<Response<dynamic>> _mapDioException(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout => const ApiError(message: 'Connection timed out. Please check your internet.'),
      DioExceptionType.sendTimeout => const ApiError(message: 'Request timed out while sending data.'),
      DioExceptionType.receiveTimeout => const ApiError(message: 'Server took too long to respond.'),
      DioExceptionType.connectionError => const ApiError(message: 'No internet connection.'),
      DioExceptionType.cancel => const ApiError(message: 'Request was cancelled.'),
      DioExceptionType.badResponse => ApiError(message: _extractErrorMessage(e) ?? 'Request failed.', statusCode: e.response?.statusCode),
      _ => ApiError(message: e.message ?? 'An unexpected error occurred.'),
    };
  }

  String? _extractErrorMessage(DioException e) {
    try {
      final body = e.response?.data;
      if (body is Map<String, dynamic>) {
        return body['message'] as String? ?? body['error'] as String? ?? body['detail'] as String?;
      }
    } catch (_) {}
    return null;
  }
}
