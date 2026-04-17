import '../../../../core/error/api_response.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUserUseCase implements UseCase<User, NoParams> {
  const GetCurrentUserUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<ApiResponse<User>> call(NoParams params) {
    return _repository.getCurrentUser();
  }
}
