import '../../../../core/error/api_response.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase implements UseCase<void, NoParams> {
  const LogoutUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<ApiResponse<void>> call(NoParams params) {
    return _repository.logout();
  }
}
