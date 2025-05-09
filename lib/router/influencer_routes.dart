import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/repositories/crash_repository.dart';
import 'package:rociny/core/repositories/influencer_repository.dart';
import 'package:rociny/features/influencer/complete_register/bloc/complete_influencer_legal_informations/complete_influencer_legal_informations_bloc.dart';
import 'package:rociny/features/influencer/complete_register/bloc/complete_influencer_profile_informations/complete_influencer_profile_informations_bloc.dart';
import 'package:rociny/features/influencer/complete_register/ui/pages/complete_influencer_legal_informations_page.dart';
import 'package:rociny/features/influencer/complete_register/ui/pages/complete_influencer_profile_informations_page.dart';
import 'package:rociny/features/influencer/complete_register/ui/pages/legal.dart';
import 'package:rociny/features/influencer/complete_register/ui/pages/my_profile_page.dart';
import 'package:rociny/features/influencer/complete_register/ui/widgets/stripe_webview.dart';
import 'package:rociny/features/influencer/home/ui/pages/home_page.dart';

List<RouteBase> kInfluencerRoutes = [
  GoRoute(
    path: '/influencer/complete_register/my_profile',
    builder: (context, state) => const MyProfilePage(),
  ),
  GoRoute(
    path: '/influencer/complete_register/complete_profile',
    builder: (context, state) => BlocProvider(
      create: (context) => CompleteInfluencerProfileInformationsBloc(
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
    path: '/influencer/complete_register/complete_stripe',
    builder: (context, state) {
      String url = state.extra as String;
      return StripeWebview(url: url);
    },
  ),
];
