part of 'collaboration_bloc.dart';

sealed class CollaborationState {}

/// ---

class InitializeLoading extends CollaborationState {}

class InitializeSuccess extends CollaborationState {}

class InitializeFailed extends CollaborationState {
  final AlertException exception;

  InitializeFailed({required this.exception});
}

/// ---

class CancelCollaborationLoading extends CollaborationState {}

class CancelCollaborationSuccess extends CollaborationState {}

class CancelCollaborationFailed extends CollaborationState {
  final AlertException exception;

  CancelCollaborationFailed({required this.exception});
}

/// ---

class SendDraftCollaborationLoading extends CollaborationState {}

class SendDraftCollaborationSuccess extends CollaborationState {}

class SendDraftCollaborationFailed extends CollaborationState {
  final AlertException exception;

  SendDraftCollaborationFailed({required this.exception});
}

/// ---

class SupplyCollaborationLoading extends CollaborationState {}

class SupplyCollaborationSuccess extends CollaborationState {}

class SupplyCollaborationFailed extends CollaborationState {
  final AlertException exception;

  SupplyCollaborationFailed({required this.exception});
}

/// ---

class ValidateCollaborationLoading extends CollaborationState {}

class ValidateCollaborationSuccess extends CollaborationState {}

class ValidateCollaborationFailed extends CollaborationState {
  final AlertException exception;

  ValidateCollaborationFailed({required this.exception});
}

/// ---

class CreateReviewLoading extends CollaborationState {}

class CreateReviewSuccess extends CollaborationState {}

class CreateReviewFailed extends CollaborationState {
  final AlertException exception;

  CreateReviewFailed({required this.exception});
}
