part of 'auth_bloc.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

class LoginLoading extends AuthState {}

class LoginFailed extends AuthState {
  final AlertException exception;

  LoginFailed({required this.exception});
}

class LoginSuccess extends AuthState {
  final AccountType accountType;

  LoginSuccess({required this.accountType});
}
