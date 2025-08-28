part of 'conversations_bloc.dart';

sealed class ConversationsState {}

/// ---

class InitializeLoading extends ConversationsState {}

class InitializeSuccess extends ConversationsState {}

class InitializeFailed extends ConversationsState {
  final AlertException exception;

  InitializeFailed({required this.exception});
}

/// ---

class RefreshConversationSuccess extends ConversationsState {}
