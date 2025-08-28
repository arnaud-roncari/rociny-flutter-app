part of 'conversations_bloc.dart';

sealed class ConversationsEvent {}

class Initialize extends ConversationsEvent {}

class RefreshConversation extends ConversationsEvent {
  final ConversationSummary summary;

  RefreshConversation({required this.summary});
}
