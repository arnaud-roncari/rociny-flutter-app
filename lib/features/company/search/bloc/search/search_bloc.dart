import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rociny/core/repositories/company_repository.dart';
import 'package:rociny/core/repositories/crash_repository.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/error_handling/api_exception.dart';
import 'package:rociny/features/company/search/data/enums/sort_type.dart';
import 'package:rociny/features/company/search/data/models/influencer_summary_model.dart';
import 'package:rociny/features/company/search/data/models/inlfuencer_filters.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({
    required this.crashRepository,
    required this.companyRepository,
  }) : super(GetInfluencersByThemeLoading()) {
    on<GetInfluencersByTheme>(getInfluencersByTheme);
    on<GetInfluencersByFilters>(getInfluencersByFilters);
    on<SortInfluencers>(sortInfluencers);
  }
  final CrashRepository crashRepository;
  final CompanyRepository companyRepository;

  /// The current theme selected for filtering influencers.
  String? theme;

  /// Filters applied to the influencers search.
  InfluencerFilters filters = InfluencerFilters();
  SortType sortType = SortType.collaborations;

  /// List of influencers fetched based on the current theme.
  List<InfluencerSummary> influencers = [];

  void getInfluencersByTheme(GetInfluencersByTheme event, Emitter<SearchState> emit) async {
    try {
      emit(GetInfluencersByThemeLoading());

      if (theme == event.theme) {
        theme = null;
      } else {
        theme = event.theme;
      }

      influencers = await companyRepository.searchInfluencersByTheme(
        theme: theme,
      );

      if (theme == null) {
        influencers.shuffle();
      }

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

  void getInfluencersByFilters(GetInfluencersByFilters event, Emitter<SearchState> emit) async {
    try {
      emit(GetInfluencersByFiltersLoading());
      theme = null;
      influencers = await companyRepository.searchInfluencersByFilters(filters);

      /// Default sort type is collaborations
      sortType = SortType.collaborations;
      sortByCollaborations();

      emit(GetInfluencersByFiltersSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(GetInfluencersByFiltersFailed(exception: alertException));
    }
  }

  void sortInfluencers(SortInfluencers event, Emitter<SearchState> emit) async {
    sortType = event.sortType;

    if (sortType == SortType.collaborations) {
      sortByCollaborations();
    } else if (sortType == SortType.followers) {
      sortByFollowers();
    } else if (sortType == SortType.notations) {
      sortByNotations();
    }
    emit(InfluencersSorted());
  }

  void sortByCollaborations() {
    /// TODO implemtion sorting by collabs and reviews
  }

  void sortByFollowers() {
    influencers.sort((a, b) => (b.followers).compareTo(a.followers));
  }

  void sortByNotations() {
    /// ...
  }
}
