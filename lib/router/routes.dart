import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/features/auth/bloc/auth/auth_bloc.dart';
import 'package:rociny/features/auth/ui/pages/first_launch_page.dart';
import 'package:rociny/features/auth/ui/pages/login_page.dart';

final GoRouter kRouter = GoRouter(
  initialLocation: getLocation(),
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => BlocProvider(
        create: (context) => AuthBloc(
          authRepository: RepositoryProvider.of(context),
          crashRepository: RepositoryProvider.of(context),
        ),
        child: const LoginPage(),
      ),
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
