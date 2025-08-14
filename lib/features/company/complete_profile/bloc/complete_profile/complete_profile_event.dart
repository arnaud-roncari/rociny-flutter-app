part of 'complete_profile_bloc.dart';

sealed class CompleteProfileEvent {}

class GetProfile extends CompleteProfileEvent {}

/// ---

class UpdateProfilePicture extends CompleteProfileEvent {}

/// ---

class UpdateName extends CompleteProfileEvent {
  final String name;

  UpdateName({required this.name});
}

/// ---

class UpdateGeolocation extends CompleteProfileEvent {
  final String geolocation;

  UpdateGeolocation({required this.geolocation});
}

/// ---

class UpdateDescription extends CompleteProfileEvent {
  final String description;

  UpdateDescription({required this.description});
}

/// ---

class AddSocialNetwork extends CompleteProfileEvent {
  final PlatformType platform;
  final String url;

  AddSocialNetwork({required this.platform, required this.url});
}

class DeleteSocialNetwork extends CompleteProfileEvent {
  final int id;

  DeleteSocialNetwork({required this.id});
}

class UpdateSocialNetwork extends CompleteProfileEvent {
  final int id;
  final String url;

  UpdateSocialNetwork({required this.id, required this.url});
}

class UpdateDocument extends CompleteProfileEvent {
  final LegalDocumentType type;

  UpdateDocument({required this.type});
}

class CreateSetupIntent extends CompleteProfileEvent {}

class UpdateTradeName extends CompleteProfileEvent {
  final String tradeName;

  UpdateTradeName({required this.tradeName});
}

class UpdateVATNumber extends CompleteProfileEvent {
  final String vatNumber;

  UpdateVATNumber({required this.vatNumber});
}

class UpdateBillingAddress extends CompleteProfileEvent {
  final String city;
  final String street;
  final String postalCode;

  UpdateBillingAddress({required this.city, required this.street, required this.postalCode});
}
