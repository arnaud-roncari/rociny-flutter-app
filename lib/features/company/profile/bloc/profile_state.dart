part of 'profile_bloc.dart';

sealed class ProfileState {}

/// ---

class ProfileUpdated extends ProfileState {}

/// ---
class GetProfileLoading extends ProfileState {}

class GetProfileSuccess extends ProfileState {}

class GetProfileFailed extends ProfileState {
  final AlertException exception;

  GetProfileFailed({required this.exception});
}

/// ---

class UpdateProfilePictureLoading extends ProfileState {}

class UpdateProfilePictureSuccess extends ProfileState {}

class UpdateProfilePictureFailed extends ProfileState {
  final AlertException exception;

  UpdateProfilePictureFailed({required this.exception});
}

// ---

class UpdateNameLoading extends ProfileState {}

class UpdateNameFailed extends ProfileState {
  final AlertException exception;

  UpdateNameFailed({required this.exception});
}

// ---

class UpdateGeolocationLoading extends ProfileState {}

class UpdateGeolocationFailed extends ProfileState {
  final AlertException exception;

  UpdateGeolocationFailed({required this.exception});
}

// ---

class UpdateDescriptionLoading extends ProfileState {}

class UpdateDescriptionFailed extends ProfileState {
  final AlertException exception;

  UpdateDescriptionFailed({required this.exception});
}

// ---

class UpdateSocialNetworkLoading extends ProfileState {}

class UpdateSocialNetworkSuccess extends ProfileState {}

class UpdateSocialNetworkFailed extends ProfileState {
  final AlertException exception;

  UpdateSocialNetworkFailed({required this.exception});
}

class AddSocialNetworkLoading extends ProfileState {}

class AddSocialNetworkSuccess extends ProfileState {}

class AddSocialNetworkFailed extends ProfileState {
  final AlertException exception;

  AddSocialNetworkFailed({required this.exception});
}

class DeleteSocialNetworkLoading extends ProfileState {}

class DeleteSocialNetworkSuccess extends ProfileState {}

class DeleteSocialNetworkFailed extends ProfileState {
  final AlertException exception;

  DeleteSocialNetworkFailed({required this.exception});
}
