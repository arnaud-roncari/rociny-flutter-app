part of 'conversation_bloc.dart';

sealed class ConversationEvent {}

class Initialize extends ConversationEvent {
  final int conversationId;

  Initialize({required this.conversationId});
}

class AddMessage extends ConversationEvent {
  final int conversationId;
  final String content;

  AddMessage({required this.content, required this.conversationId});
}

class ReceivedMessage extends ConversationEvent {
  final Message message;

  ReceivedMessage({required this.message});
}
