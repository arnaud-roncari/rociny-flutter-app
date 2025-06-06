part of 'settings_bloc.dart';

sealed class SettingsEvent {}

class GetIsRegisteredLocally extends SettingsEvent {}

class UpdatePassword extends SettingsEvent {
  final String password;
  final String newPassword;

  UpdatePassword({required this.password, required this.newPassword});
}

class UpdateEmail extends SettingsEvent {
  final String password;
  final String newEmail;

  UpdateEmail({required this.password, required this.newEmail});
}

class VerifyUpdateEmail extends SettingsEvent {
  final int code;

  VerifyUpdateEmail({required this.code});
}

class OnResentUpdateEmailVerificationCode extends SettingsEvent {}

class OnLogout extends SettingsEvent {}

class OnDeleteAccount extends SettingsEvent {}

class GetCompanySectionsStatus extends SettingsEvent {}

class UpdateLegalDocument extends SettingsEvent {
  final LegalDocumentType type;

  UpdateLegalDocument({required this.type});
}

class GetLegalDocumentsStatus extends SettingsEvent {}

class GetStripeAccountLink extends SettingsEvent {}

class GetStripeLoginLink extends SettingsEvent {}

class SetStripeAccountStatus extends SettingsEvent {}

class GetFacebookSession extends SettingsEvent {}

class GetInstagramAccounts extends SettingsEvent {}

class CreateInstagramAccount extends SettingsEvent {
  final String fetchedInstagramAccountId;

  CreateInstagramAccount({required this.fetchedInstagramAccountId});
}

class LogoutFacebook extends SettingsEvent {}
