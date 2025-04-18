part of 'auth_bloc.dart';

sealed class AuthEvent {}

class OnLogin extends AuthEvent {
  final String email;
  final String password;

  OnLogin({required this.email, required this.password});
}

class OnRegister extends AuthEvent {
  final String email;
  final String password;
  final AccountType accountType;

  OnRegister({required this.email, required this.password, required this.accountType});
}

class OnVerifyRegisterCode extends AuthEvent {
  final int code;

  OnVerifyRegisterCode({required this.code});
}

class OnResentRegisterVerificationCode extends AuthEvent {}

class OnForgotPassword extends AuthEvent {
  final String email;

  OnForgotPassword({required this.email});
}

class OnResentForgotPasswordVerificationCode extends AuthEvent {}

class OnCodeEnteredForgotPassword extends AuthEvent {
  final int code;

  OnCodeEnteredForgotPassword({required this.code});
}

class OnNewPasswordEntered extends AuthEvent {
  final String password;

  OnNewPasswordEntered({required this.password});
}
