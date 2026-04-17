sealed class ApiResponse<T> {
  const ApiResponse();
}

final class ApiSuccess<T> extends ApiResponse<T> {
  final T data;
  const ApiSuccess(this.data);
}

final class ApiError<T> extends ApiResponse<T> {
  final String message;
  final int? statusCode;
  const ApiError({required this.message, this.statusCode});
}
