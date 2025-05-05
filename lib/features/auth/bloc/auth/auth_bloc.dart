import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/constants/storage_keys.dart';
import 'package:rociny/core/repositories/crash_repository.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/error_handling/api_exception.dart';
import 'package:rociny/features/auth/data/dto/login_with_google_dto.dart';
import 'package:rociny/features/auth/data/enums/account_type.dart';
import 'package:rociny/features/auth/data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.authRepository, required this.crashRepository}) : super(AuthInitial()) {
    on<OnLogin>(login);
    on<OnRegister>(register);
    on<OnVerifyRegisterCode>(verifyRegisterCode);
    on<OnResentRegisterVerificationCode>(registerCodeVerificationResentEmail);
    on<OnForgotPassword>(forgotPassword);
    on<OnResentForgotPasswordVerificationCode>(forgotPasswordCodeVerificationResentEmail);
    on<OnCodeEnteredForgotPassword>(setCodePasswordForgot);
    on<OnNewPasswordEntered>(verifyForgotPassword);
    on<OnLoginWithGoogle>(loginWithGoogle);
    on<OnLoginWithApple>(loginWithApple);
    on<OnCompleteAccounType>(completeAccountType);
  }
  final AuthRepository authRepository;
  final CrashRepository crashRepository;

  /// Stores the email address during the registration process.
  String? emailToRegister;

  /// Stores the account type during the registration process.
  AccountType? accountTypeToRegister;

  /// Stores the email address used for the password recovery process.
  String? emailForgotPassword;
  int? codeForgotPassword;

  String? providerUserId;

  void login(OnLogin event, Emitter<AuthState> emit) async {
    try {
      emit(LoginLoading());
      await Future.delayed(const Duration(seconds: 1));
      kJwt = await authRepository.login(event.email, event.password);

      /// The JWT is saved in the client's keystore.
      /// This allows the client, on startup, to check if there is an existing session.
      /// If so, the user won't need to log in again.
      /// For subsequent requests, this JWT will be sent to the API to verify the session and identify the requester.
      FlutterSecureStorage storage = const FlutterSecureStorage();
      await storage.write(key: kKeyJwt, value: kJwt);

      /// Extract account type from JWT.
      Map<String, dynamic> decodedToken = JwtDecoder.decode(kJwt!);
      AccountType accountType = AccountTypeExtension.fromString(decodedToken['account_type']);

      emit(LoginSuccess(accountType: accountType));
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(LoginFailed(exception: alertException));
    }
  }

  void register(OnRegister event, Emitter<AuthState> emit) async {
    try {
      emit(RegisterLoading());

      await authRepository.register(
        event.email,
        event.password,
        event.accountType,
      );

      accountTypeToRegister = event.accountType;
      emailToRegister = event.email;

      emit(RegisterSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(RegisterFailed(exception: alertException));
    }
  }

  void verifyRegisterCode(OnVerifyRegisterCode event, Emitter<AuthState> emit) async {
    try {
      emit(RegisterCodeVerificationLoading());

      kJwt = await authRepository.verifyRegisterCode(
        emailToRegister!,
        event.code,
      );
      FlutterSecureStorage storage = const FlutterSecureStorage();
      await storage.write(key: kKeyJwt, value: kJwt);

      emit(RegisterCodeVerificationSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(RegisterCodeVerificationFailed(exception: alertException));
    }
  }

  void registerCodeVerificationResentEmail(OnResentRegisterVerificationCode event, Emitter<AuthState> emit) async {
    try {
      await authRepository.resentRegisterVerificationCode(emailToRegister!);
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(RegisterCodeVerificationFailed(exception: alertException));
    }
  }

  void forgotPassword(OnForgotPassword event, Emitter<AuthState> emit) async {
    try {
      emit(ForgotPasswordLoading());
      emailForgotPassword = event.email;
      await authRepository.forgotPassword(emailForgotPassword!);
      emit(ForgotPasswordSuccess());
    } catch (exception, stack) {
      /// Emit success if already resetting password.
      if (exception is ApiException && exception.id == "security:user:already_resetting_password") {
        emit(ForgotPasswordSuccess());
        return;
      }

      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(ForgotPasswordFailed(exception: alertException));
    }
  }

  void setCodePasswordForgot(OnCodeEnteredForgotPassword event, Emitter<AuthState> emit) async {
    codeForgotPassword = event.code;
  }

  void verifyForgotPassword(OnNewPasswordEntered event, Emitter<AuthState> emit) async {
    try {
      emit(ForgotPasswordVerificationLoading());
      await authRepository.verifyForgotPasswordCode(emailForgotPassword!, event.password, codeForgotPassword!);

      /// Set jwt to null
      kJwt = null;
      FlutterSecureStorage storage = const FlutterSecureStorage();
      await storage.write(key: kKeyJwt, value: kJwt);

      emit(ForgotPasswordVerificationSuccess());
    } catch (exception, stack) {
      /// Emit success if already resetting password.
      if (exception is ApiException && exception.id == "security:user:already_resetting_password") {
        emit(ForgotPasswordSuccess());
        return;
      }

      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(ForgotPasswordVerificationFailed(exception: alertException));
    }
  }

  void forgotPasswordCodeVerificationResentEmail(
    OnResentForgotPasswordVerificationCode event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await authRepository.resentForgotPasswordVerificationCode(emailForgotPassword!);
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(RegisterCodeVerificationFailed(exception: alertException));
    }
  }

  void loginWithGoogle(OnLoginWithGoogle event, Emitter<AuthState> emit) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );

      GoogleSignInAccount? user = await googleSignIn.signIn();
      if (user == null) {
        return;
      }

      final GoogleSignInAuthentication auth = await user.authentication;
      final String? idToken = auth.idToken;

      if (idToken == null) {
        return;
      }

      LoginWithGoogleDto dto = await authRepository.loginWithGoogle(idToken);

      if (dto.status == "logged") {
        kJwt = dto.jwt;

        /// The JWT is saved in the client's keystore.
        /// This allows the client, on startup, to check if there is an existing session.
        /// If so, the user won't need to log in again.
        /// For subsequent requests, this JWT will be sent to the API to verify the session and identify the requester.
        FlutterSecureStorage storage = const FlutterSecureStorage();
        await storage.write(key: kKeyJwt, value: kJwt);

        /// Extract account type from JWT.
        Map<String, dynamic> decodedToken = JwtDecoder.decode(kJwt!);
        AccountType accountType = AccountTypeExtension.fromString(decodedToken['account_type']);

        emit(LoginSuccess(accountType: accountType));
      } else {
        providerUserId = dto.providerUserId;
        emit(CompleteAccountType());
      }
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(LoginWithGoogleFailed(exception: alertException));
    }
  }

  void loginWithApple(OnLoginWithApple event, Emitter<AuthState> emit) async {
    // try {
    //   /// TODO
    // } catch (exception, stack) {
    // if (exception is! ApiException) {
    //   crashRepository.registerCrash(exception, stack);
    // }

    /// Format exception to be displayed.
    // AlertException alertException = AlertException.fromException(exception);
    // emit(LoginWithGoogleFailed(exception: alertException)); changer
    // }
  }

  void completeAccountType(OnCompleteAccounType event, Emitter<AuthState> emit) async {
    try {
      emit(CompleteAccountTypeLoading());

      /// faire la meme requete poura pple et google ?
      kJwt = await authRepository.completeAuthGoogleUser(providerUserId!, event.accountType);

      FlutterSecureStorage storage = const FlutterSecureStorage();
      await storage.write(key: kKeyJwt, value: kJwt);

      emit(CompleteAccountTypeSuccess(accountType: event.accountType));
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(CompleteAccountTypeFailed(exception: alertException));
    }
  }
}
