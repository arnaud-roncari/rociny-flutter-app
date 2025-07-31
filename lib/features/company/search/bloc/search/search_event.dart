part of 'search_bloc.dart';

sealed class SearchEvent {}

class GetInfluencersByTheme extends SearchEvent {
  final String? theme;

  GetInfluencersByTheme({required this.theme});
}

class GetInfluencersByFilters extends SearchEvent {}

class SortInfluencers extends SearchEvent {
  final SortType sortType;

  SortInfluencers({required this.sortType});
}
