part of 'preview_bloc.dart';

sealed class PreviewState {}

class Initial extends PreviewState {}

/// ---

class InitializeLoading extends PreviewState {}

class InitializeSuccess extends PreviewState {}

class InitializeFailed extends PreviewState {
  final AlertException exception;

  InitializeFailed({required this.exception});
}

/// ---

class StepUpdated extends PreviewState {
  final int index;

  StepUpdated({required this.index});
}
