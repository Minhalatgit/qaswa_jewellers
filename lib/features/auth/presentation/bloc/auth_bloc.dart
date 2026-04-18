import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/error/api_response.dart';
import '../../../../core/services/services.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required StorageService storage,
  })  : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _storage = storage,
        super(AuthInitial()) {
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthStatusChecked>(_onAuthStatusChecked);
  }

  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final StorageService _storage;

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final response = await _loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );
    switch (response) {
      case ApiSuccess(:final data):
        emit(AuthAuthenticated(data));
      case ApiError(:final message):
        emit(AuthError(message));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final response = await _logoutUseCase(NoParams());
    switch (response) {
      case ApiSuccess():
        emit(AuthUnauthenticated());
      case ApiError(:final message):
        emit(AuthError(message));
    }
  }

  Future<void> _onAuthStatusChecked(
    AuthStatusChecked event,
    Emitter<AuthState> emit,
  ) async {
    final token = await _storage.read(StorageKeys.accessToken);
    if (token == null) {
      emit(AuthUnauthenticated());
      return;
    }
    final response = await _getCurrentUserUseCase(NoParams());
    switch (response) {
      case ApiSuccess(:final data):
        emit(AuthAuthenticated(data));
      case ApiError():
        await _storage.delete(StorageKeys.accessToken);
        emit(AuthUnauthenticated());
    }
  }
}
