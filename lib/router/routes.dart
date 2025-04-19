import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/repositories/crash_repository.dart';
import 'package:rociny/core/repositories/influencer_repository.dart';
import 'package:rociny/features/auth/ui/pages/first_launch_page.dart';
import 'package:rociny/features/auth/ui/pages/forgot_password_code_verification_page.dart';
import 'package:rociny/features/auth/ui/pages/forgot_password_new_password.dart';
import 'package:rociny/features/auth/ui/pages/forgot_password_page.dart';
import 'package:rociny/features/auth/ui/pages/login_page.dart';
import 'package:rociny/features/auth/ui/pages/register_code_verification_page.dart';
import 'package:rociny/features/auth/ui/pages/register_page.dart';
import 'package:rociny/features/influencer/complete_register/bloc/complete_profile_informations/complete_profile_informations_bloc.dart';
import 'package:rociny/features/influencer/complete_register/ui/pages/complete_influencer_profile_informations_page.dart';
import 'package:rociny/features/influencer/complete_register/ui/pages/my_profile_page.dart';
import 'package:rociny/shared/widgets/preview_pdf.dart';

final GoRouter kRouter = GoRouter(
  initialLocation: getLocation(),
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/first_launch',
      builder: (context, state) => const FirstLaunchPage(),
    ),
    GoRoute(
      path: '/register/code_verification',
      builder: (context, state) => const RegisterCodeVerificationPage(),
    ),
    GoRoute(
      path: '/forgot_password',
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: '/forgot_password/code_verification',
      builder: (context, state) => const ForgotPasswordCodeVerificationPage(),
    ),
    GoRoute(
      path: '/forgot_password/new_password',
      builder: (context, state) => const ForgotPasswordNewPasswordPage(),
    ),
    GoRoute(
      path: '/preview_pdf',
      builder: (context, state) {
        String url = state.extra as String;
        return PreviewPdfPage(url: url);
      },
    ),
    GoRoute(
      path: '/influencer/complete_register/my_profile',
      builder: (context, state) => const MyProfilePage(),
    ),
    GoRoute(
      path: '/influencer/complete_register/complete_profile',
      builder: (context, state) => BlocProvider(
        create: (context) => CompleteProfileInformationsBloc(
          crashRepository: RepositoryProvider.of<CrashRepository>(context),
          influencerRepository: RepositoryProvider.of<InfluencerRepository>(context),
        ),
        child: const CompleteInfluencerProfileInformationsPage(),
      ),
    ),
  ],
);

String getLocation() {
  return "/influencer/complete_register/complete_profile";
  if (kFirstLaunch) {
    return '/first_launch';
  }
  return kJwt == null ? '/login' : '/home';
}
