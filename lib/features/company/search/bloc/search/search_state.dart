part of 'search_bloc.dart';

sealed class SearchState {}

class Initial extends SearchState {}

/// ---

class GetInfluencersByThemeLoading extends SearchState {}

class GetInfluencersByThemeSuccess extends SearchState {}

class GetInfluencersByThemeFailed extends SearchState {
  final AlertException exception;

  GetInfluencersByThemeFailed({required this.exception});
}

/// ---

class GetInfluencersByFiltersLoading extends SearchState {}

class GetInfluencersByFiltersSuccess extends SearchState {}

class GetInfluencersByFiltersFailed extends SearchState {
  final AlertException exception;

  GetInfluencersByFiltersFailed({required this.exception});
}

/// ---

class InfluencersSorted extends SearchState {}
