part of 'auth_bloc.dart';

sealed class AuthEvent {}

class OnLogin extends AuthEvent {
  final String email;
  final String password;

  OnLogin({required this.email, required this.password});
}
