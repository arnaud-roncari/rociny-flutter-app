import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/constants/storage_keys.dart';
import 'package:rociny/core/repositories/crash_repository.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/auth/bloc/auth/auth_bloc.dart';
import 'package:rociny/features/auth/data/repositories/auth_repository.dart';
import 'package:rociny/router/routes.dart';
import 'package:rociny/shared/decorations/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// The JWT is stored as a global variable, fetched from the client's keystore.
  /// Other services will be able to use the JWT, such as the router to define which initial route to display,
  /// or repositories when making requests.
  FlutterSecureStorage storage = const FlutterSecureStorage();
  kJwt = await storage.read(key: kKeyJwt);

  /// The language should also be stored in the keystore.
  /// Whenever the language is modified, it should be updated in the keystore.
  /// Then, both during updates and at startup, the value is loaded into a global variable,
  /// making it easier to use for translations.
  kLanguage = await storage.read(key: kKeyLanguage) ?? "fr";

  /// Translations are loaded from a JSON file.
  await TranslationExtension.loadTranslations();

  /// Redirect user on "first launch" screens if true.
  kFirstLaunch = await storage.read(key: kKeyFirstLaunch) == null;

  runApp(const RocinyApp());
}

class RocinyApp extends StatelessWidget {
  const RocinyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => CrashRepository()),
      ],
      child: Builder(
        builder: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => AuthBloc(
                  authRepository: RepositoryProvider.of<AuthRepository>(context),
                  crashRepository: RepositoryProvider.of<CrashRepository>(context),
                ),
              ),
            ],
            child: MaterialApp.router(
              theme: kTheme,
              routerConfig: kRouter,
            ),
          );
        },
      ),
    );
  }
}
