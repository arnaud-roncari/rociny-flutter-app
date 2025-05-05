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

class CompleteAccountType extends AuthState {}

class CompleteAccountTypeFailed extends AuthState {
  final AlertException exception;

  CompleteAccountTypeFailed({required this.exception});
}

class CompleteAccountTypeSuccess extends AuthState {
  final AccountType accountType;

  CompleteAccountTypeSuccess({required this.accountType});
}

class CompleteAccountTypeLoading extends AuthState {}

class LoginWithGoogleFailed extends AuthState {
  final AlertException exception;

  LoginWithGoogleFailed({required this.exception});
}

class RegisterLoading extends AuthState {}

class RegisterFailed extends AuthState {
  final AlertException exception;

  RegisterFailed({required this.exception});
}

class RegisterSuccess extends AuthState {}

class RegisterCodeVerificationLoading extends AuthState {}

class RegisterCodeVerificationFailed extends AuthState {
  final AlertException exception;

  RegisterCodeVerificationFailed({required this.exception});
}

class RegisterCodeVerificationSuccess extends AuthState {}

class ForgotPasswordLoading extends AuthState {}

class ForgotPasswordFailed extends AuthState {
  final AlertException exception;

  ForgotPasswordFailed({required this.exception});
}

class ForgotPasswordSuccess extends AuthState {}

class ForgotPasswordVerificationLoading extends AuthState {}

class ForgotPasswordVerificationFailed extends AuthState {
  final AlertException exception;

  ForgotPasswordVerificationFailed({required this.exception});
}

class ForgotPasswordVerificationSuccess extends AuthState {}
