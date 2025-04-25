part of 'complete_legal_informations_bloc.dart';

sealed class CompleteLegalInformationsState {}

class CompleteLegalInitial extends CompleteLegalInformationsState {}

class UpdateDocumentFailed extends CompleteLegalInformationsState {
  final AlertException exception;

  UpdateDocumentFailed({required this.exception});
}

class UpdateDocumentSuccess extends CompleteLegalInformationsState {}
