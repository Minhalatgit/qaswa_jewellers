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
      if (result case ApiError(:final message, :final statusCode)) {
        return ApiError(message: message, statusCode: statusCode);
      }
      final data = (result as ApiSuccess).data;
      await _storage.write(StorageKeys.accessToken, data.accessToken);
      return ApiSuccess(data.user.toEntity());
    } catch (e) {
      return ApiError(message: e.toString());
    }
  }

  @override
  Future<ApiResponse<void>> logout() async {
    try {
      final result = await _remoteDataSource.logout();
      if (result case ApiError(:final message, :final statusCode)) {
        return ApiError(message: message, statusCode: statusCode);
      }
      await _storage.delete(StorageKeys.accessToken);
      return const ApiSuccess(null);
    } catch (e) {
      return ApiError(message: e.toString());
    }
  }

  @override
  Future<ApiResponse<User>> getCurrentUser() async {
    try {
      final result = await _remoteDataSource.getCurrentUser();
      return switch (result) {
        ApiError(:final message, :final statusCode) =>
          ApiError(message: message, statusCode: statusCode),
        ApiSuccess(:final data) => ApiSuccess(data.toEntity()),
      };
    } catch (e) {
      return ApiError(message: e.toString());
    }
  }
}
