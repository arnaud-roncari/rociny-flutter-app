import 'package:go_router/go_router.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/features/auth/ui/pages/login_page.dart';

/// TODO Faire routes (prendre type de compte en consideration) (dans le JWT ?)
final GoRouter kRouter = GoRouter(
  initialLocation: kJwt == null ? '/login' : '/home',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    // GoRoute(
    //   path: '/home',
    //   builder: (context, state) => const HomePage(),
    // ),
  ],
);
