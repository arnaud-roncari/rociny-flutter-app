import 'package:go_router/go_router.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/features/auth/ui/pages/first_launch_page.dart';
import 'package:rociny/features/auth/ui/pages/login_page.dart';

/// TODO Faire routes (prendre type de compte en consideration) (dans le JWT ?)
final GoRouter kRouter = GoRouter(
  initialLocation: getLocation(),
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/first_launch',
      builder: (context, state) => const FirstLaunchPage(),
    ),
  ],
);

String getLocation() {
  if (kFirstLaunch) {
    return '/first_launch';
  }
  return kJwt == null ? '/login' : '/home';
}
