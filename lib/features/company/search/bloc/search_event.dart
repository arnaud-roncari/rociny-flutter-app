part of 'search_bloc.dart';

sealed class SearchEvent {}

class GetInfluencersByTheme extends SearchEvent {
  final String? theme;

  GetInfluencersByTheme({required this.theme});
}
