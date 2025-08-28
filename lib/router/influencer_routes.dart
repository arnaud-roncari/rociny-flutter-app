import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/repositories/conversation_gateway.dart';
import 'package:rociny/core/repositories/crash_repository.dart';
import 'package:rociny/core/repositories/influencer_repository.dart';
import 'package:rociny/features/auth/data/repositories/auth_repository.dart';
import 'package:rociny/features/influencer/collaborations/bloc/collaboration_bloc.dart';
import 'package:rociny/features/influencer/collaborations/bloc/collaborations_bloc.dart';
import 'package:rociny/features/influencer/collaborations/bloc/preview_bloc.dart';
import 'package:rociny/features/influencer/collaborations/ui/pages/collaboration_page.dart';
import 'package:rociny/features/influencer/collaborations/ui/pages/preview_company_page.dart';
import 'package:rociny/features/influencer/collaborations/ui/pages/review_page.dart';
import 'package:rociny/features/influencer/conversation/bloc/conversation_bloc.dart';
import 'package:rociny/features/influencer/conversation/bloc/conversations_bloc.dart';
import 'package:rociny/features/influencer/conversation/ui/pages/conversation_page.dart';
import 'package:rociny/features/influencer/dashboard/bloc/dashboard_bloc.dart';
import 'package:rociny/features/influencer/profile/bloc/profile_bloc.dart';
import 'package:rociny/features/influencer/profile/ui/pages/update_description_page.dart';
import 'package:rociny/features/influencer/profile/ui/pages/update_geolocation.dart';
import 'package:rociny/features/influencer/profile/ui/pages/update_name_page.dart';
import 'package:rociny/features/influencer/profile/ui/pages/update_portfolio_page.dart';
import 'package:rociny/features/influencer/profile/ui/pages/update_social_networks_page.dart';
import 'package:rociny/features/influencer/profile/ui/pages/update_target_audience_page.dart';
import 'package:rociny/features/influencer/profile/ui/pages/update_themes_page.dart';
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
import 'package:rociny/features/influencer/complete_profile/bloc/complete_profile/complete_profile_bloc.dart';
import 'package:rociny/features/influencer/complete_profile/ui/pages/complete_legal_page.dart';
import 'package:rociny/features/influencer/complete_profile/ui/pages/complete_profile_page.dart';
import 'package:rociny/features/influencer/complete_profile/ui/pages/legal_illustration_page.dart';
import 'package:rociny/features/influencer/complete_profile/ui/pages/profile_illustration_page.dart';
import 'package:rociny/features/influencer/home/ui/pages/home_page.dart';
import 'package:rociny/features/influencer/settings/ui/pages/stripe_page.dart';
import 'package:rociny/features/influencer/settings/ui/pages/update_vat_number_page.dart';

List<RouteBase> kInfluencerRoutes = [
  ShellRoute(
    builder: (context, state, child) {
      return BlocProvider(
        create: (_) => CompleteProfileBloc(
          authRepository: RepositoryProvider.of<AuthRepository>(context),
          crashRepository: RepositoryProvider.of<CrashRepository>(context),
          influencerRepository: RepositoryProvider.of<InfluencerRepository>(context),
        ),
        child: child,
      );
    },
    routes: [
      GoRoute(
        path: '/influencer/complete_profile/profile_illustration',
        builder: (context, state) => const ProfileIllustrationPage(),
      ),
      GoRoute(
        path: '/influencer/complete_profile/profile',
        builder: (context, state) => const CompleteProfilPage(),
      ),
      GoRoute(
        path: '/influencer/complete_profile/legal_illustration',
        builder: (context, state) => const LegalIllustrationPage(),
      ),
      GoRoute(path: '/influencer/complete_profile/legal', builder: (context, state) => const CompleteLegalPage()),
    ],
  ),
  ShellRoute(
    builder: (context, state, child) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => ProfileBloc(
              crashRepository: context.read<CrashRepository>(),
              influencerRepository: context.read<InfluencerRepository>(),
            ),
            child: child,
          ),
          BlocProvider(
            create: (_) => SettingsBloc(
              crashRepository: context.read<CrashRepository>(),
              influencerRepository: context.read<InfluencerRepository>(),
              authRepository: context.read<AuthRepository>(),
            ),
            child: child,
          ),
          BlocProvider(
            create: (_) => CollaborationsBloc(
              crashRepository: context.read<CrashRepository>(),
              influencerRepository: context.read<InfluencerRepository>(),
            ),
            child: child,
          ),
          BlocProvider(
            create: (_) => DashboardBloc(
              crashRepository: context.read<CrashRepository>(),
              influencerRepository: context.read<InfluencerRepository>(),
            ),
            child: child,
          ),
          BlocProvider(
            create: (_) => ConversationsBloc(
              crashRepository: context.read<CrashRepository>(),
              influencerRepository: context.read<InfluencerRepository>(),
              conversationGateway: context.read<ConversationGateway>(),
            ),
            child: child,
          ),
        ],
        child: child,
      );
    },
    routes: [
      GoRoute(
        path: '/influencer/home',
        builder: (context, state) => const HomePage(),
        routes: [
          /// Conversation
          ShellRoute(
            builder: (context, state, child) {
              return BlocProvider(
                create: (_) => ConversationBloc(
                  crashRepository: context.read<CrashRepository>(),
                  influencerRepository: context.read<InfluencerRepository>(),
                  conversationGateway: context.read<ConversationGateway>(),
                ),
                child: child,
              );
            },
            routes: [
              GoRoute(
                path: 'conversation',
                builder: (context, state) {
                  Map data = state.extra as Map;
                  int conversationId = data["conversation_id"];
                  String companyName = data["company_name"];
                  String companyProfilePicture = data["company_profile_picture"];
                  return ConversationPage(
                    conversationId: conversationId,
                    companyName: companyName,
                    companyProfilePicture: companyProfilePicture,
                  );
                },
              ),
            ],
          ),

          /// Collaborations
          ShellRoute(
            builder: (context, state, child) {
              return BlocProvider(
                create: (context) => CollaborationBloc(
                  crashRepository: context.read<CrashRepository>(),
                  influencerRepository: context.read<InfluencerRepository>(),
                ),
                child: child,
              );
            },
            routes: [
              GoRoute(
                path: 'preview_collaboration',
                builder: (context, state) {
                  final extra = state.extra as Map<String, dynamic>?;
                  int userId = extra?["user_id"] as int;
                  int collaborationId = extra?["collaboration_id"] as int;
                  return CollaborationPage(
                    userId: userId,
                    collaborationId: collaborationId,
                  );
                },
                routes: [
                  GoRoute(
                    path: 'review',
                    builder: (context, state) {
                      return const ReviewPage();
                    },
                  ),
                ],
              ),
            ],
          ),

          /// Profile
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
          GoRoute(
            path: 'profile/themes',
            builder: (context, state) => const UpdateThemesPage(),
          ),
          GoRoute(
            path: 'profile/target_audience',
            builder: (context, state) => const UpdateTargetAudiencePage(),
          ),
          GoRoute(
            path: 'profile/portfolio',
            builder: (context, state) => const UpdatePorfolioPage(),
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
              GoRoute(
                path: 'company',
                builder: (context, state) => const CompanyPage(),
                routes: [
                  GoRoute(
                    path: 'legal-documents',
                    builder: (context, state) => const LegalDocumentsPage(),
                  ),
                  GoRoute(
                    path: 'stripe',
                    builder: (context, state) => const StripePage(),
                    routes: const [],
                  ),
                  GoRoute(
                    path: 'vat',
                    builder: (context, state) => const UpdateVatNumberPage(),
                  ),
                ],
              ),
            ],
          ),

          /// Preview company
          ShellRoute(
            builder: (context, state, child) {
              return BlocProvider(
                create: (_) => PreviewBloc(
                  crashRepository: context.read<CrashRepository>(),
                  influencerRepository: context.read<InfluencerRepository>(),
                ),
                child: child,
              );
            },
            routes: [
              GoRoute(
                path: 'preview',
                builder: (context, state) {
                  int userId = state.extra as int;
                  return PreviewCompanyPage(
                    userId: userId,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  ),
];
