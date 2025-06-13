import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/repositories/crash_repository.dart';
import 'package:rociny/core/repositories/influencer_repository.dart';
import 'package:rociny/features/auth/data/repositories/auth_repository.dart';
import 'package:rociny/features/influencer/settings/bloc/settings_bloc.dart';
import 'package:rociny/features/influencer/settings/ui/pages/company_page.dart';
import 'package:rociny/features/influencer/settings/ui/pages/credentials_page.dart';
import 'package:rociny/features/influencer/settings/ui/pages/email_code_verification_page.dart';
import 'package:rociny/features/influencer/settings/ui/pages/email_page.dart';
import 'package:rociny/features/influencer/settings/ui/pages/instagram_page.dart';
import 'package:rociny/features/influencer/settings/ui/pages/legal_documents_page.dart';
import 'package:rociny/features/influencer/settings/ui/pages/notifications_page.dart';
import 'package:rociny/features/influencer/settings/ui/pages/password_page.dart';
import 'package:rociny/features/influencer/settings/ui/pages/policies_page.dart';
import 'package:rociny/features/influencer/settings/ui/pages/settings_page.dart';
import 'package:rociny/features/influencer/complete_register/bloc/complete_influencer_legal_informations/complete_influencer_legal_informations_bloc.dart';
import 'package:rociny/features/influencer/complete_register/bloc/complete_influencer_profile_informations/complete_influencer_profile_informations_bloc.dart';
import 'package:rociny/features/influencer/complete_register/ui/pages/complete_influencer_legal_informations_page.dart';
import 'package:rociny/features/influencer/complete_register/ui/pages/complete_influencer_profile_informations_page.dart';
import 'package:rociny/features/influencer/complete_register/ui/pages/legal.dart';
import 'package:rociny/features/influencer/complete_register/ui/pages/my_profile_page.dart';
import 'package:rociny/features/influencer/complete_register/ui/widgets/stripe_webview.dart';
import 'package:rociny/features/influencer/home/ui/pages/home_page.dart';
import 'package:rociny/features/influencer/settings/ui/pages/stripe_page.dart';

List<RouteBase> kInfluencerRoutes = [
  GoRoute(
    path: '/influencer/complete_register/my_profile',
    builder: (context, state) => const MyProfilePage(),
  ),
  GoRoute(
    path: '/influencer/complete_register/complete_profile',
    builder: (context, state) => BlocProvider(
      create: (context) => CompleteInfluencerProfileInformationsBloc(
        authRepository: RepositoryProvider.of<AuthRepository>(context),
        crashRepository: RepositoryProvider.of<CrashRepository>(context),
        influencerRepository: RepositoryProvider.of<InfluencerRepository>(context),
      ),
      child: const CompleteInfluencerProfileInformationsPage(),
    ),
  ),
  GoRoute(
    path: '/influencer/complete_register/legal',
    builder: (context, state) => const LegalPage(),
  ),
  GoRoute(
    path: '/influencer/home',
    builder: (context, state) => const HomePage(),
  ),
  GoRoute(
    path: '/influencer/complete_register/complete_legal',
    builder: (context, state) => BlocProvider(
      create: (context) => CompleteInfluencerLegalInformationsBloc(
        crashRepository: RepositoryProvider.of<CrashRepository>(context),
        influencerRepository: RepositoryProvider.of<InfluencerRepository>(context),
      ),
      child: const CompleteInfluencerLegalInformationsPage(),
    ),
  ),
  GoRoute(
    path: '/influencer/complete_register/stripe/webview',
    builder: (context, state) {
      String url = state.extra as String;
      return StripeWebview(url: url);
    },
  ),
  ShellRoute(
    builder: (context, state, child) {
      return BlocProvider(
        create: (_) => SettingsBloc(
          crashRepository: context.read<CrashRepository>(),
          influencerRepository: context.read<InfluencerRepository>(),
          authRepository: context.read<AuthRepository>(),
        ),
        child: child,
      );
    },

    /// TODO bouger dans /home

    routes: [
      GoRoute(
        path: '/influencer/settings',
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
