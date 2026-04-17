import '../models/login_response_model.dart';
import '../models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<LoginResponseModel> login(String email, String password);
  Future<void> logout();
  Future<UserModel> getCurrentUser();
}
