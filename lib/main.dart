import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/constants/storage_keys.dart';
import 'package:rociny/core/repositories/company_repository.dart';
import 'package:rociny/core/repositories/conversation_gateway.dart';
import 'package:rociny/core/repositories/crash_repository.dart';
import 'package:rociny/core/repositories/influencer_repository.dart';
import 'package:rociny/core/utils/helpers/department_helper.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/core/utils/helpers/target_audience_helper.dart';
import 'package:rociny/core/utils/helpers/theme_helper.dart';
import 'package:rociny/features/auth/bloc/auth/auth_bloc.dart';
import 'package:rociny/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:rociny/router/routes.dart';
import 'package:rociny/shared/decorations/theme.dart';

/// TODO Retirer dans complete prpoofile documents (inf et entr)
/// TODO retirerdans settings (inf | ent) documents
/// TODO dans get CompletionProfile retirer le check documents (ent | inf)

/// TODO  puis tester samsung
/// TODO update visules, sup compte et refaire flow (insta et stripe), ipohje opuis samsung

/// TODO MAJ les visuels dans le onboarding et complétion profil (heck tous les illustration)

/// TODO il faut peut etre refaire la clés pour le auth, et coché sandbox et production (oauth apple)
/// NOTE : Pour mise en prod:
/// - mettre api en prod
/// - mettre cgu et pc
/// - changer les apikey stripe front et back (celle de prod)
/// - maj webhook stripe
/// - mettre leystore de production avec le sha1 (nécésasire pour le googlesign)
/// - maj le fichier apple google oauth (pour sigin google)
/// - changer app version dans environnement
/// - changer l'url de redirection dans developer.facebook (debug avec ngrok en attendant)
/// - setup insta en version prod (faire soumission, changer redirect_url sur site, front et back)
///  - définir rociny vat dans .env, dans backend (génération de facture)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR');

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

  /// Load the list of departments into a global variable.
  /// This is used throughout the app for features requiring department data.
  kDepartments = await DepartmentHelper.loadDepartments();

  /// Load the themes into a global variable.
  /// This is used to dynamically apply themes throughout the app.
  kThemes = await ThemeHelper.loadThemes();

  /// Load the target audience data into a global variable.
  /// This is used for features that depend on audience segmentation.
  kTargetAudiences = await TargetAudienceHelper.loadTargetAudience();

  /// Redirect user on "first launch" screens if true.
  kFirstLaunch = await storage.read(key: kKeyFirstLaunch) == null;

  /// Commission (can be loaded from API later)
  kCommission = 0.10;

  /// Stripe
  Stripe.publishableKey = kStripePublishableKey;

  /// One Signal
  OneSignal.initialize(kOneSignalPublishableKey);
  OneSignal.Notifications.requestPermission(true);

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
        RepositoryProvider(create: (context) => InfluencerRepository()),
        RepositoryProvider(create: (context) => CompanyRepository()),
        RepositoryProvider(create: (context) => ConversationGateway()),
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
