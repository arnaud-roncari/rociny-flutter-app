part of 'conversation_bloc.dart';

sealed class ConversationState {}

/// ---

class InitializeLoading extends ConversationState {}

class InitializeSuccess extends ConversationState {}

class InitializeFailed extends ConversationState {
  final AlertException exception;

  InitializeFailed({required this.exception});
}

/// ---

class AddMessageLoading extends ConversationState {}

class AddMessageSuccess extends ConversationState {}

class AddMessageFailed extends ConversationState {
  final AlertException exception;

  AddMessageFailed({required this.exception});
}

/// ---

class ReceivedMessageSuccess extends ConversationState {}
