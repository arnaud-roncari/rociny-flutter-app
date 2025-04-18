import 'package:go_router/go_router.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/features/auth/ui/pages/first_launch_page.dart';
import 'package:rociny/features/auth/ui/pages/forgot_password_code_verification_page.dart';
import 'package:rociny/features/auth/ui/pages/forgot_password_new_password.dart';
import 'package:rociny/features/auth/ui/pages/forgot_password_page.dart';
import 'package:rociny/features/auth/ui/pages/login_page.dart';
import 'package:rociny/features/auth/ui/pages/register_code_verification_page.dart';
import 'package:rociny/features/auth/ui/pages/register_page.dart';

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
  ],
);

String getLocation() {
  if (kFirstLaunch) {
    return '/first_launch';
  }
  return kJwt == null ? '/login' : '/home';
}
