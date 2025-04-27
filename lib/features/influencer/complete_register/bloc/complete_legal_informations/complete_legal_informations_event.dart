part of 'complete_legal_informations_bloc.dart';

sealed class CompleteLegalInformationsEvent {}

class UpdateDocument extends CompleteLegalInformationsEvent {
  final LegalDocumentType type;

  UpdateDocument({required this.type});
}

class GetStripeAccountLink extends CompleteLegalInformationsEvent {}

class SetStripeAccountStatus extends CompleteLegalInformationsEvent {}
