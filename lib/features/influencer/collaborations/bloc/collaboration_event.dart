part of 'collaboration_bloc.dart';

sealed class CollaborationEvent {}

class Initialize extends CollaborationEvent {
  final int userId;
  final int collaborationId;

  Initialize({required this.userId, required this.collaborationId});
}

/// ---

class AcceptCollaboration extends CollaborationEvent {}

/// ---

class RefuseCollaboration extends CollaborationEvent {}

/// ---

class EndCollaboration extends CollaborationEvent {}

/// ---

class CreateReview extends CollaborationEvent {
  final int stars;
  final String description;

  CreateReview({required this.stars, required this.description});
}
