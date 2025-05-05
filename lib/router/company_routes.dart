import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/repositories/company_repository.dart';
import 'package:rociny/core/repositories/crash_repository.dart';
import 'package:rociny/features/company/complete_register/bloc/complete_company_legal_informations/complete_company_legal_informations_bloc.dart';
import 'package:rociny/features/company/complete_register/bloc/complete_company_profile_informations/complete_company_profile_informations_bloc.dart';
import 'package:rociny/features/company/complete_register/ui/pages/complete_company_legal_informations_page.dart';
import 'package:rociny/features/company/complete_register/ui/pages/complete_company_profile_informations_page.dart';
import 'package:rociny/features/company/complete_register/ui/pages/legal.dart';
import 'package:rociny/features/company/complete_register/ui/pages/my_profile_page.dart';
import 'package:rociny/features/company/home/ui/pages/home_page.dart';

List<RouteBase> kCompanyRoutes = [
  GoRoute(
    path: '/company/complete_register/my_profile',
    builder: (context, state) => const MyProfilePage(),
  ),
  GoRoute(
    path: '/company/complete_register/complete_profile',
    builder: (context, state) => BlocProvider(
      create: (context) => CompleteCompanyProfileInformationsBloc(
        crashRepository: RepositoryProvider.of<CrashRepository>(context),
        companyRepository: RepositoryProvider.of<CompanyRepository>(context),
      ),
      child: const CompleteCompanyProfileInformationsPage(),
    ),
  ),
  GoRoute(
    path: '/company/complete_register/legal',
    builder: (context, state) => const LegalPage(),
  ),
  GoRoute(
    path: '/company/home',
    builder: (context, state) => const HomePage(),
  ),
  GoRoute(
    path: '/company/complete_register/complete_legal',
    builder: (context, state) => BlocProvider(
      create: (context) => CompleteCompanyLegalInformationsBloc(
        crashRepository: RepositoryProvider.of<CrashRepository>(context),
        companyRepository: RepositoryProvider.of<CompanyRepository>(context),
      ),
      child: const CompleteCompanyLegalInformationsPage(),
    ),
  ),
];
