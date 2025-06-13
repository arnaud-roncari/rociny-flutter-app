import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/repositories/company_repository.dart';
import 'package:rociny/core/repositories/crash_repository.dart';
import 'package:rociny/features/auth/data/repositories/auth_repository.dart';
import 'package:rociny/features/company/complete_profile/bloc/complete_profile/complete_profile_bloc.dart';
import 'package:rociny/features/company/complete_profile/ui/pages/complete_legal_page.dart';
import 'package:rociny/features/company/complete_profile/ui/pages/complete_profile_page.dart';
import 'package:rociny/features/company/complete_profile/ui/pages/complete_legal_informations.dart';
import 'package:rociny/features/company/complete_profile/ui/pages/complete_profile_informations_page.dart';
import 'package:rociny/features/company/home/ui/pages/home_page.dart';
import 'package:rociny/features/company/profile/bloc/profile_bloc.dart';
import 'package:rociny/features/company/profile/ui/pages/update_description_page.dart';
import 'package:rociny/features/company/profile/ui/pages/update_name_geolocation.dart';
import 'package:rociny/features/company/profile/ui/pages/update_name_page.dart';
import 'package:rociny/features/company/profile/ui/pages/update_social_networks_page.dart';
import 'package:rociny/features/company/settings/bloc/settings_bloc.dart';
import 'package:rociny/features/company/settings/ui/pages/company_page.dart';
import 'package:rociny/features/company/settings/ui/pages/credentials_page.dart';
import 'package:rociny/features/company/settings/ui/pages/email_code_verification_page.dart';
import 'package:rociny/features/company/settings/ui/pages/email_page.dart';
import 'package:rociny/features/company/settings/ui/pages/instagram_page.dart';
import 'package:rociny/features/company/settings/ui/pages/legal_documents_page.dart';
import 'package:rociny/features/company/settings/ui/pages/notifications_page.dart';
import 'package:rociny/features/company/settings/ui/pages/password_page.dart';
import 'package:rociny/features/company/settings/ui/pages/policies_page.dart';
import 'package:rociny/features/company/settings/ui/pages/settings_page.dart';
import 'package:rociny/features/company/settings/ui/pages/stripe_page.dart';
import 'package:rociny/features/influencer/complete_register/ui/widgets/stripe_webview.dart';

/// TODO rework les routes de complete (les embriquer avec 1  bloc)
/// TODO rework les routes de settings à embriquer avec home
List<RouteBase> kCompanyRoutes = [
  GoRoute(
    path: '/company/complete_register/my_profile',
    builder: (context, state) => const ProfilePage(),
  ),
  GoRoute(
    path: '/company/complete_register/complete_profile',
    builder: (context, state) => BlocProvider(
      create: (context) => CompleteProfileBloc(
        authRepository: RepositoryProvider.of<AuthRepository>(context),
        crashRepository: RepositoryProvider.of<CrashRepository>(context),
        companyRepository: RepositoryProvider.of<CompanyRepository>(context),
      ),
      child: const CompleteCompanyProfileInformationsPage(),
    ),
  ),
  GoRoute(
    path: '/company/complete_register/legal',
    builder: (context, state) => const LegalPage(),
  ),
  GoRoute(
    path: '/company/complete_register/complete_legal',
    builder: (context, state) => const CompleteCompanyLegalInformationsPage(),
  ),
  GoRoute(
    path: '/company/complete_register/stripe/webview',
    builder: (context, state) {
      String url = state.extra as String;
      return StripeWebview(url: url);
    },
  ),
  ShellRoute(
    builder: (context, state, child) {
      return BlocProvider(
        create: (_) => ProfileBloc(
          crashRepository: context.read<CrashRepository>(),
          companyRepository: context.read<CompanyRepository>(),
        ),
        child: child,
      );
    },
    routes: [
      GoRoute(
        path: '/company/home',
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            path: 'profile/name',
            builder: (context, state) => const UpdateNamePage(),
          ),
          GoRoute(
            path: 'profile/geolocation',
            builder: (context, state) => const UpdateGeolocationPage(),
          ),
          GoRoute(
            path: 'profile/description',
            builder: (context, state) => const UpdateDescriptionPage(),
          ),
          GoRoute(
            path: 'profile/social_networks',
            builder: (context, state) => const UpdateSocialNetworksPage(),
          ),
        ],
      ),
    ],
  ),

  /// TODO bouger dans /home
  ShellRoute(
    builder: (context, state, child) {
      return BlocProvider(
        create: (_) => SettingsBloc(
          crashRepository: context.read<CrashRepository>(),
          companyRepository: context.read<CompanyRepository>(),
          authRepository: context.read<AuthRepository>(),
        ),
        child: child,
      );
    },
    routes: [
      GoRoute(
        path: '/company/settings',
        builder: (context, state) => const SettingsPage(),
        routes: [
          GoRoute(
            path: 'credentials',
            builder: (context, state) => const CredentialsPage(),
            routes: [
              GoRoute(path: 'email', builder: (context, state) => const EmailPage(), routes: [
                GoRoute(
                  path: 'code-verification',
                  builder: (context, state) => const EmailCodeVerificationPage(),
                ),
              ]),
              GoRoute(
                path: 'password',
                builder: (context, state) => const PasswordPage(),
              ),
              GoRoute(
                path: 'instagram',
                builder: (context, state) => const InstagramPage(),
              ),
            ],
          ),
          GoRoute(
            path: 'policies',
            builder: (context, state) => const PoliciesPage(),
          ),
          GoRoute(
            path: 'notifications',
            builder: (context, state) => const NotificationsPage(),
          ),
          GoRoute(path: 'company', builder: (context, state) => const CompanyPage(), routes: [
            GoRoute(
              path: 'legal-documents',
              builder: (context, state) => const LegalDocumentsPage(),
            ),
            GoRoute(path: 'stripe', builder: (context, state) => const StripePage(), routes: [
              GoRoute(
                path: 'webview',
                builder: (context, state) {
                  String url = state.extra as String;
                  return StripeWebview(url: url);
                },
              ),
            ]),
          ]),
        ],
      ),
    ],
  ),
];
