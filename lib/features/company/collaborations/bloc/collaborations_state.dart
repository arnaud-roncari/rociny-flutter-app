part of 'collaborations_bloc.dart';

sealed class CollaborationsState {}

/// ---

class InitializeLoading extends CollaborationsState {}

class InitializeSuccess extends CollaborationsState {}

class InitializeFailed extends CollaborationsState {
  final AlertException exception;

  InitializeFailed({required this.exception});
}
