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

class AcceptCollaborationLoading extends CollaborationState {}

class AcceptCollaborationSuccess extends CollaborationState {}

class AcceptCollaborationFailed extends CollaborationState {
  final AlertException exception;

  AcceptCollaborationFailed({required this.exception});
}

/// ---

class RefuseCollaborationLoading extends CollaborationState {}

class RefuseCollaborationSuccess extends CollaborationState {}

class RefuseCollaborationFailed extends CollaborationState {
  final AlertException exception;

  RefuseCollaborationFailed({required this.exception});
}

/// ---

class EndCollaborationLoading extends CollaborationState {}

class EndCollaborationSuccess extends CollaborationState {}

class EndCollaborationFailed extends CollaborationState {
  final AlertException exception;

  EndCollaborationFailed({required this.exception});
}

/// ---

class CreateReviewLoading extends CollaborationState {}

class CreateReviewSuccess extends CollaborationState {}

class CreateReviewFailed extends CollaborationState {
  final AlertException exception;

  CreateReviewFailed({required this.exception});
}
