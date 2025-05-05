part of 'complete_influencer_legal_informations_bloc.dart';

sealed class CompleteInfluencerLegalInformationsState {}

class CompleteLegalInitial extends CompleteInfluencerLegalInformationsState {}

class UpdateDocumentFailed extends CompleteInfluencerLegalInformationsState {
  final AlertException exception;

  UpdateDocumentFailed({required this.exception});
}

class UpdateDocumentSuccess extends CompleteInfluencerLegalInformationsState {}

class GetStripeAccountLinkFailed extends CompleteInfluencerLegalInformationsState {
  final AlertException exception;

  GetStripeAccountLinkFailed({required this.exception});
}

class GetStripeAccountLinkSuccess extends CompleteInfluencerLegalInformationsState {}

class GetStripeAccountLinkLoading extends CompleteInfluencerLegalInformationsState {}

class StripeAccountCompleted extends CompleteInfluencerLegalInformationsState {}
