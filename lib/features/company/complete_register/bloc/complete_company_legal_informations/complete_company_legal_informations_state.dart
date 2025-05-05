part of 'complete_company_legal_informations_bloc.dart';

sealed class CompleteCompanyLegalInformationsState {}

class CompleteLegalInitial extends CompleteCompanyLegalInformationsState {}

class UpdateDocumentFailed extends CompleteCompanyLegalInformationsState {
  final AlertException exception;

  UpdateDocumentFailed({required this.exception});
}

class UpdateDocumentSuccess extends CompleteCompanyLegalInformationsState {}

class CreateSetupIntentLoading extends CompleteCompanyLegalInformationsState {}

class CreateSetupIntentSuccess extends CompleteCompanyLegalInformationsState {}

class CreateSetupIntentFailed extends CompleteCompanyLegalInformationsState {
  final AlertException exception;

  CreateSetupIntentFailed({required this.exception});
}
