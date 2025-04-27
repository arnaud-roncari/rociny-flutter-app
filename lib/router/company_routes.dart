import 'package:go_router/go_router.dart';
import 'package:rociny/features/company/home/pages/home_page.dart';

List<RouteBase> kCompanyRoutes = [
  /// TODO faire complete register entreprise
  GoRoute(
    path: '/company/home',
    builder: (context, state) => const HomePage(),
  ),
];
