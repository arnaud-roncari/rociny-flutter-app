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

class CreateSetupIntent extends SettingsEvent {}

class GetFacebookSession extends SettingsEvent {}

class GetInstagramAccounts extends SettingsEvent {}

class CreateInstagramAccount extends SettingsEvent {
  final String fetchedInstagramAccountId;

  CreateInstagramAccount({required this.fetchedInstagramAccountId});
}

class LogoutFacebook extends SettingsEvent {}

class UpdateTradeName extends SettingsEvent {
  final String tradeName;

  UpdateTradeName({required this.tradeName});
}

class UpdateVATNumber extends SettingsEvent {
  final String vatNumber;

  UpdateVATNumber({required this.vatNumber});
}

class UpdateBillingAddress extends SettingsEvent {
  final String city;
  final String street;
  final String postalCode;

  UpdateBillingAddress({required this.city, required this.street, required this.postalCode});
}
