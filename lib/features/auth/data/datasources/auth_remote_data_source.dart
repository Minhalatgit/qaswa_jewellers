import '../../../../core/error/api_response.dart';
import '../models/login_response_model.dart';
import '../models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<ApiResponse<LoginResponseModel>> login(String email, String password);
  Future<ApiResponse<void>> logout();
  Future<ApiResponse<UserModel>> getCurrentUser();
}
