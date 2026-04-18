import 'package:dio/dio.dart';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/error/api_response.dart';
import '../../../../core/services/services.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required StorageService storage,
  })  : _remoteDataSource = remoteDataSource,
        _storage = storage;

  final AuthRemoteDataSource _remoteDataSource;
  final StorageService _storage;

  @override
  Future<ApiResponse<User>> login(String email, String password) async {
    try {
      final result = await _remoteDataSource.login(email, password);
      await _storage.write(StorageKeys.accessToken, result.accessToken);
      return ApiSuccess(result.user.toEntity());
    } on DioException catch (e) {
      return ApiError(
        message: e.message ?? 'Login failed',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return ApiError(message: e.toString());
    }
  }

  @override
  Future<ApiResponse<void>> logout() async {
    try {
      await _remoteDataSource.logout();
      await _storage.delete(StorageKeys.accessToken);
      return const ApiSuccess(null);
    } on DioException catch (e) {
      return ApiError(
        message: e.message ?? 'Logout failed',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return ApiError(message: e.toString());
    }
  }

  @override
  Future<ApiResponse<User>> getCurrentUser() async {
    try {
      final model = await _remoteDataSource.getCurrentUser();
      return ApiSuccess(model.toEntity());
    } on DioException catch (e) {
      return ApiError(
        message: e.message ?? 'Failed to fetch user',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return ApiError(message: e.toString());
    }
  }
}
