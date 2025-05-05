part of 'complete_company_legal_informations_bloc.dart';

sealed class CompleteCompanyLegalInformationsEvent {}

class UpdateDocument extends CompleteCompanyLegalInformationsEvent {
  final LegalDocumentType type;

  UpdateDocument({required this.type});
}

class CreateSetupIntent extends CompleteCompanyLegalInformationsEvent {}
