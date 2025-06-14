import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/repositories/company_repository.dart';
import 'package:rociny/core/repositories/crash_repository.dart';
import 'package:rociny/features/auth/data/repositories/auth_repository.dart';
import 'package:rociny/features/company/complete_profile/bloc/complete_profile/complete_profile_bloc.dart';
import 'package:rociny/features/company/complete_profile/ui/pages/complete_legal_page.dart';
import 'package:rociny/features/company/complete_profile/ui/pages/complete_profile_page.dart';
import 'package:rociny/features/company/complete_profile/ui/pages/legal_illustration.dart';
import 'package:rociny/features/company/complete_profile/ui/pages/profile_illustration_page.dart';
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

List<RouteBase> kCompanyRoutes = [
  ShellRoute(
    builder: (context, state, child) {
      return BlocProvider(
        create: (_) => CompleteProfileBloc(
          authRepository: RepositoryProvider.of<AuthRepository>(context),
          crashRepository: RepositoryProvider.of<CrashRepository>(context),
          companyRepository: RepositoryProvider.of<CompanyRepository>(context),
        ),
        child: child,
      );
    },
    routes: [
      GoRoute(
        path: '/company/complete_profile/profile_illustration',
        builder: (context, state) => const ProfileIllustrationPage(),
      ),
      GoRoute(
        path: '/company/complete_profile/profile',
        builder: (context, state) => const CompleteProfilePage(),
      ),
      GoRoute(
        path: '/company/complete_profile/legal_illustration',
        builder: (context, state) => const LegalIllustrationPage(),
      ),
      GoRoute(
        path: '/company/complete_profile/legal',
        builder: (context, state) => const CompleteLegalPage(),
      ),
    ],
  ),

  /// Home
  ShellRoute(
    builder: (context, state, child) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => ProfileBloc(
              crashRepository: context.read<CrashRepository>(),
              companyRepository: context.read<CompanyRepository>(),
            ),
            child: child,
          ),
          BlocProvider(
            create: (_) => SettingsBloc(
              crashRepository: context.read<CrashRepository>(),
              companyRepository: context.read<CompanyRepository>(),
              authRepository: context.read<AuthRepository>(),
            ),
            child: child,
          ),
        ],
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

          /// Settings
          GoRoute(
            path: 'settings',
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
                GoRoute(
                  path: 'stripe',
                  builder: (context, state) => const StripePage(),
                ),
              ]),
            ],
          ),
        ],
      ),
    ],
  ),
];
