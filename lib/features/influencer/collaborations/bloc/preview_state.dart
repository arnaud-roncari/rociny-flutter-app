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

/// ---

class ProductPlacementCreated extends PreviewState {}

class ProductPlacementRemoved extends PreviewState {}

class ProductPlacementUpdated extends PreviewState {}

/// ---

class FilesUpdated extends PreviewState {}

/// ---

class CreateCollaborationLoading extends PreviewState {}

class CreateCollaborationSuccess extends PreviewState {}

class CreateCollaborationFailed extends PreviewState {
  final AlertException exception;

  CreateCollaborationFailed({required this.exception});
}

/// ---

class GetProductPlacementPriceLoading extends PreviewState {}

class GetProductPlacementPriceSuccess extends PreviewState {}

class GetProductPlacementPriceFailed extends PreviewState {
  final AlertException exception;

  GetProductPlacementPriceFailed({required this.exception});
}
