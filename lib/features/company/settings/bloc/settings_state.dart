part of 'settings_bloc.dart';

sealed class SettingsState {}

class SettingsInitial extends SettingsState {}

/// ---

class GetIsRegisteredLocallyLoading extends SettingsState {}

class GetIsRegisteredLocallySuccess extends SettingsState {}

class GetIsRegisteredLocallyFailed extends SettingsState {
  final AlertException exception;

  GetIsRegisteredLocallyFailed({required this.exception});
}

/// ---

class UpdatePasswordLoading extends SettingsState {}

class UpdatePasswordSuccess extends SettingsState {}

class UpdatePasswordFailed extends SettingsState {
  final AlertException exception;

  UpdatePasswordFailed({required this.exception});
}

/// ---

class UpdateEmailLoading extends SettingsState {}

class UpdateEmailSuccess extends SettingsState {}

class UpdateEmailFailed extends SettingsState {
  final AlertException exception;

  UpdateEmailFailed({required this.exception});
}

/// ---

class VerifyUpdateEmailSuccess extends SettingsState {}

class VerifyUpdateEmailFailed extends SettingsState {
  final AlertException exception;

  VerifyUpdateEmailFailed({required this.exception});
}

/// ---

class ResentUpdateEmailVerificationCodeFailed extends SettingsState {
  final AlertException exception;

  ResentUpdateEmailVerificationCodeFailed({required this.exception});
}

/// ---

class GetCompanySectionsStatusLoading extends SettingsState {}

class GetCompanySectionsStatusSuccess extends SettingsState {}

class GetCompanySectionsStatusFailed extends SettingsState {
  final AlertException exception;

  GetCompanySectionsStatusFailed({required this.exception});
}

/// ---

class UpdateLegalDocumentFailed extends SettingsState {
  final AlertException exception;

  UpdateLegalDocumentFailed({required this.exception});
}

class UpdateLegalDocumentSuccess extends SettingsState {}

/// ---

class GetLegalDocumentsStatusFailed extends SettingsState {
  final AlertException exception;

  GetLegalDocumentsStatusFailed({required this.exception});
}

class GetLegalDocumentsStatusSuccess extends SettingsState {}

class GetLegalDocumentsStatusLoading extends SettingsState {}

class GetStripeAccountStatus extends SettingsState {}

// ---

class CreateSetupIntentLoading extends SettingsState {}

class CreateSetupIntentSuccess extends SettingsState {}

class CreateSetupIntentFailed extends SettingsState {
  final AlertException exception;

  CreateSetupIntentFailed({required this.exception});
}

// ---

class GetFacebookSessionLoading extends SettingsState {}

class GetFacebookSessionSuccess extends SettingsState {}

class GetFacebookSessionFailed extends SettingsState {
  final AlertException exception;

  GetFacebookSessionFailed({required this.exception});
}

/// ---

class GetInstagramAccountsLoading extends SettingsState {}

class GetInstagramAccountsSuccess extends SettingsState {}

class GetInstagramAccountsFailed extends SettingsState {
  final AlertException exception;

  GetInstagramAccountsFailed({required this.exception});
}

/// ---

class CreateInstagramAccountLoading extends SettingsState {}

class CreateInstagramAccountSuccess extends SettingsState {}

class CreateInstagramAccountFailed extends SettingsState {
  final AlertException exception;

  CreateInstagramAccountFailed({required this.exception});
}

/// ---

class LogoutFacebookLoading extends SettingsState {}

class LogoutFacebookSuccess extends SettingsState {}

class LogoutFacebookFailed extends SettingsState {
  final AlertException exception;

  LogoutFacebookFailed({required this.exception});
}
