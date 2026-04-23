import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/api_response.dart';
import '../models/login_response_model.dart';
import '../models/user_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<ApiResponse<LoginResponseModel>> login(
    String email,
    String password,
  ) async {
    final result = await _apiClient.post(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );
    return switch (result) {
      ApiError(:final message, :final statusCode) => ApiError(message: message, statusCode: statusCode),
      ApiSuccess(:final data) => ApiSuccess(
        LoginResponseModel.fromJson(data.data as Map<String, dynamic>),
      ),
    };
  }

  @override
  Future<ApiResponse<void>> logout() async {
    final result = await _apiClient.post(ApiConstants.logout);
    return switch (result) {
      ApiError(:final message, :final statusCode) => ApiError(message: message, statusCode: statusCode),
      ApiSuccess() => const ApiSuccess(null),
    };
  }

  @override
  Future<ApiResponse<UserModel>> getCurrentUser() async {
    final result = await _apiClient.get(ApiConstants.currentUser);
    return switch (result) {
      ApiError(:final message, :final statusCode) => ApiError(message: message, statusCode: statusCode),
      ApiSuccess(:final data) => ApiSuccess(
        UserModel.fromJson(data.data as Map<String, dynamic>),
      ),
    };
  }
}
