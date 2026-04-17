part of 'auth_bloc.dart';

sealed class AuthEvent {}

final class AuthLoginRequested extends AuthEvent {
  AuthLoginRequested({required this.email, required this.password});

  final String email;
  final String password;
}

final class AuthLogoutRequested extends AuthEvent {}

final class AuthStatusChecked extends AuthEvent {}
