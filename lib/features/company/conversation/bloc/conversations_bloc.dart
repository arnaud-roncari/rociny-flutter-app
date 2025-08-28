import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rociny/core/repositories/company_repository.dart';
import 'package:rociny/core/repositories/conversation_gateway.dart';
import 'package:rociny/core/repositories/crash_repository.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/error_handling/api_exception.dart';
import 'package:rociny/features/influencer/conversation/data/models/conversation_model.dart';

part 'conversations_event.dart';
part 'conversations_state.dart';

class ConversationsBloc extends Bloc<ConversationsEvent, ConversationsState> {
  ConversationsBloc({
    required this.crashRepository,
    required this.companyRepository,
    required this.conversationGateway,
  }) : super(InitializeLoading()) {
    on<Initialize>(initialize);
    on<RefreshConversation>(refreshConversation);
  }
  final CrashRepository crashRepository;
  final CompanyRepository companyRepository;
  final ConversationGateway conversationGateway;

  StreamSubscription? st;

  List<ConversationSummary> summaries = [];

  void initialize(Initialize event, Emitter<ConversationsState> emit) async {
    try {
      emit(InitializeLoading());
      summaries = await companyRepository.getAllConversations();

      /// Gateway
      conversationGateway.connect();
      st = conversationGateway.eventsStream.listen((event) {
        if (event['type'] == 'refresh_conversation') {
          ConversationSummary summary = ConversationSummary.fromJson(event["data"]);
          add(RefreshConversation(summary: summary));
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

  void refreshConversation(RefreshConversation event, Emitter<ConversationsState> emit) async {
    ConversationSummary summary = event.summary;

    bool newSummary = true;
    for (ConversationSummary s in summaries) {
      if (s.id == summary.id) {
        s.refresh(summary);
        newSummary = false;
      }
    }

    if (newSummary) {
      summaries.add(summary);
    }

    emit(RefreshConversationSuccess());
  }

  @override
  Future<void> close() {
    st?.cancel();
    return super.close();
  }
}
