import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/constants/storage_keys.dart';
import 'package:rociny/core/repositories/crash_repository.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/error_handling/api_exception.dart';
import 'package:rociny/features/auth/data/enums/account_type.dart';
import 'package:rociny/features/auth/data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.authRepository, required this.crashRepository}) : super(AuthInitial()) {
    on<OnLogin>(login);
  }
  final AuthRepository authRepository;
  final CrashRepository crashRepository;

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
}
