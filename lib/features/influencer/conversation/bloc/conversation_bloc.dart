import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rociny/core/repositories/conversation_gateway.dart';
import 'package:rociny/core/repositories/crash_repository.dart';
import 'package:rociny/core/repositories/influencer_repository.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/error_handling/api_exception.dart';
import 'package:rociny/features/influencer/conversation/data/models/message_model.dart';

part 'conversation_event.dart';
part 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  ConversationBloc({
    required this.crashRepository,
    required this.influencerRepository,
    required this.conversationGateway,
  }) : super(InitializeLoading()) {
    on<Initialize>(initialize);
    on<AddMessage>(addMessage);
    on<ReceivedMessage>(receivedMessage);
  }
  final CrashRepository crashRepository;
  final InfluencerRepository influencerRepository;
  final ConversationGateway conversationGateway;
  List<Message> messages = [];
  StreamSubscription? st;

  void initialize(Initialize event, Emitter<ConversationState> emit) async {
    try {
      emit(InitializeLoading());
      messages = await influencerRepository.getMessagesByConversation(event.conversationId);
      await influencerRepository.markConversationMessagesAsRead(event.conversationId);

      /// Gateway
      st = conversationGateway.eventsStream.listen((event) {
        if (event['type'] == 'add_message') {
          Message message = Message.fromJson(event["data"]);
          add(ReceivedMessage(message: message));
        }
      });

      emit(InitializeSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(InitializeFailed(exception: alertException));
    }
  }

  void receivedMessage(ReceivedMessage event, Emitter<ConversationState> emit) async {
    Message message = event.message;
    if (message.conversationId != messages[0].conversationId) {
      return;
    }
    messages.add(message);
    await influencerRepository.markConversationMessagesAsRead(message.conversationId);
    emit(ReceivedMessageSuccess());
  }

  void addMessage(AddMessage event, Emitter<ConversationState> emit) async {
    try {
      emit(AddMessageLoading());
      await influencerRepository.addMessage(
        event.conversationId,
        event.content,
      );
      emit(AddMessageSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(AddMessageFailed(exception: alertException));
    }
  }

  @override
  Future<void> close() {
    st?.cancel();
    return super.close();
  }
}
