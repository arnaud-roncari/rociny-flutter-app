part of 'complete_influencer_legal_informations_bloc.dart';

sealed class CompleteInfluencerLegalInformationsEvent {}

class UpdateDocument extends CompleteInfluencerLegalInformationsEvent {
  final LegalDocumentType type;

  UpdateDocument({required this.type});
}

class GetStripeAccountLink extends CompleteInfluencerLegalInformationsEvent {}

class SetStripeAccountStatus extends CompleteInfluencerLegalInformationsEvent {}

class GetStripeLoginLink extends CompleteInfluencerLegalInformationsEvent {}
