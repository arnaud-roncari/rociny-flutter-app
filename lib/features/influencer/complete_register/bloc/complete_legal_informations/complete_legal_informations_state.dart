part of 'complete_legal_informations_bloc.dart';

sealed class CompleteLegalInformationsState {}

class CompleteLegalInitial extends CompleteLegalInformationsState {}

class UpdateDocumentFailed extends CompleteLegalInformationsState {
  final AlertException exception;

  UpdateDocumentFailed({required this.exception});
}

class UpdateDocumentSuccess extends CompleteLegalInformationsState {}

class GetStripeAccountLinkFailed extends CompleteLegalInformationsState {
  final AlertException exception;

  GetStripeAccountLinkFailed({required this.exception});
}

class GetStripeAccountLinkSuccess extends CompleteLegalInformationsState {}

class GetStripeAccountLinkLoading extends CompleteLegalInformationsState {}

class StripeAccountCompleted extends CompleteLegalInformationsState {}
