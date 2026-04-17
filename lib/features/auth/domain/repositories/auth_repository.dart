import '../../../../core/error/api_response.dart';
import '../entities/user.dart';

abstract interface class AuthRepository {
  Future<ApiResponse<User>> login(String email, String password);
  Future<ApiResponse<void>> logout();
  Future<ApiResponse<User>> getCurrentUser();
}
