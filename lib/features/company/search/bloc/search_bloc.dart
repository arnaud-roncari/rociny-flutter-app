import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rociny/core/repositories/company_repository.dart';
import 'package:rociny/core/repositories/crash_repository.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/error_handling/api_exception.dart';

part 'search_event.dart';
part 'ssearch_state.dart';

/// TODO ajouter une var (is profile coomplted dans les user) (ou faire une mefa query sql)
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({
    required this.crashRepository,
    required this.companyRepository,
  }) : super(Initial()) {
    on<GetInfluencersByTheme>(getInfluencersByTheme);
  }
  final CrashRepository crashRepository;
  final CompanyRepository companyRepository;

  String? theme;

  void getInfluencersByTheme(GetInfluencersByTheme event, Emitter<SearchState> emit) async {
    try {
      emit(GetInfluencersByThemeLoading());
      theme = event.theme;

      /// get by theme
      /// shuffle if theme is null

      emit(GetInfluencersByThemeSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(GetInfluencersByThemeFailed(exception: alertException));
    }
  }
}
