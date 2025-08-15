import 'dart:io';

import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/features/auth/data/enums/account_type.dart';
import 'package:rociny/features/auth/ui/pages/complete_account_type_page.dart';
import 'package:rociny/features/auth/ui/pages/first_launch_page.dart';
import 'package:rociny/features/auth/ui/pages/forgot_password_code_verification_page.dart';
import 'package:rociny/features/auth/ui/pages/forgot_password_new_password.dart';
import 'package:rociny/features/auth/ui/pages/forgot_password_page.dart';
import 'package:rociny/features/auth/ui/pages/login_page.dart';
import 'package:rociny/features/auth/ui/pages/register_code_verification_page.dart';
import 'package:rociny/features/auth/ui/pages/register_page.dart';
import 'package:rociny/router/company_routes.dart';
import 'package:rociny/router/influencer_routes.dart';
import 'package:rociny/shared/pages/facebook_page.dart';
import 'package:rociny/shared/pages/preview_picture_page.dart';
import 'package:rociny/shared/widgets/preview_network_pdf.dart';
import 'package:rociny/shared/widgets/preview_pdf.dart';

/// TODO ajouter instagram comme reseau social (préparer le début des url)
final GoRouter kRouter = GoRouter(
  initialLocation: getLocation(),
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/complete_account_type',
      builder: (context, state) => const CompleteAccountTypePage(),
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
      path: '/preview_pdf/network',
      builder: (context, state) {
        String url = state.extra as String;
        return PreviewNetworkPdfPage(url: url);
      },
    ),
    GoRoute(
      path: '/preview_pdf',
      builder: (context, state) {
        File file = state.extra as File;
        return PreviewPdfPage(file: file);
      },
    ),
    ...kInfluencerRoutes,
    ...kCompanyRoutes,

    /// Shared
    GoRoute(
      path: '/facebook',
      builder: (context, state) => const FacebookPage(),
    ),
    GoRoute(
        path: '/preview_picture',
        builder: (context, state) {
          Map extra = state.extra as Map;
          String endpoint = extra["endpoint"] as String;
          void Function()? onDeleted = extra["onDeleted"] as void Function()?;

          return PreviewPicturePage(
            endpoint: endpoint,
            onDeleted: onDeleted,
          );
        }),
  ],
);

String getLocation() {
  // return "/login";
  // return "/company/complete_profile/profile_illustration";

  if (kFirstLaunch) {
    return '/first_launch';
  }

  if (kJwt == null) {
    return '/login';
  }

  /// Extract account type from JWT.

  Map<String, dynamic> decodedToken = JwtDecoder.decode(kJwt!);
  AccountType accountType = AccountTypeExtension.fromString(decodedToken['account_type']);

  if (accountType == AccountType.company) {
    return '/company/home';
  }

  return '/influencer/home';
}
