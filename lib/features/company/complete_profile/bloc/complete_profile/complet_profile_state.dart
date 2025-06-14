part of 'complete_profile_bloc.dart';

sealed class CompleteProfileState {}

/// ---

class ProfileUpdated extends CompleteProfileState {}

/// ---
class GetProfileLoading extends CompleteProfileState {}

class GetProfileSuccess extends CompleteProfileState {}

class GetProfileFailed extends CompleteProfileState {
  final AlertException exception;

  GetProfileFailed({required this.exception});
}

/// ---

class UpdateProfilePictureLoading extends CompleteProfileState {}

class UpdateProfilePictureSuccess extends CompleteProfileState {}

class UpdateProfilePictureFailed extends CompleteProfileState {
  final AlertException exception;

  UpdateProfilePictureFailed({required this.exception});
}

// ---

class UpdateNameLoading extends CompleteProfileState {}

class UpdateNameFailed extends CompleteProfileState {
  final AlertException exception;

  UpdateNameFailed({required this.exception});
}

// ---

class UpdateGeolocationLoading extends CompleteProfileState {}

class UpdateGeolocationFailed extends CompleteProfileState {
  final AlertException exception;

  UpdateGeolocationFailed({required this.exception});
}

// ---

class UpdateDescriptionLoading extends CompleteProfileState {}

class UpdateDescriptionFailed extends CompleteProfileState {
  final AlertException exception;

  UpdateDescriptionFailed({required this.exception});
}

// ---

class UpdateSocialNetworkLoading extends CompleteProfileState {}

class UpdateSocialNetworkSuccess extends CompleteProfileState {}

class UpdateSocialNetworkFailed extends CompleteProfileState {
  final AlertException exception;

  UpdateSocialNetworkFailed({required this.exception});
}

class AddSocialNetworkLoading extends CompleteProfileState {}

class AddSocialNetworkSuccess extends CompleteProfileState {}

class AddSocialNetworkFailed extends CompleteProfileState {
  final AlertException exception;

  AddSocialNetworkFailed({required this.exception});
}

class DeleteSocialNetworkLoading extends CompleteProfileState {}

class DeleteSocialNetworkSuccess extends CompleteProfileState {}

class DeleteSocialNetworkFailed extends CompleteProfileState {
  final AlertException exception;

  DeleteSocialNetworkFailed({required this.exception});
}

/// ---
class UpdateDocumentFailed extends CompleteProfileState {
  final AlertException exception;

  UpdateDocumentFailed({required this.exception});
}

class UpdateDocumentSuccess extends CompleteProfileState {}

/// ---

class CreateSetupIntentLoading extends CompleteProfileState {}

class CreateSetupIntentSuccess extends CompleteProfileState {}

class CreateSetupIntentFailed extends CompleteProfileState {
  final AlertException exception;

  CreateSetupIntentFailed({required this.exception});
}
