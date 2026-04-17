import '../error/api_response.dart';

abstract class UseCase<ReturnType, Params> {
  Future<ApiResponse<ReturnType>> call(Params params);
}

class NoParams {}
