part of 'complete_profile_bloc.dart';

sealed class CompleteProfileState {}

class CompleteProfileInitial extends CompleteProfileState {}

/// ---

class ProfileUpdated extends CompleteProfileState {}

/// ---
class UpdateVATNumberLoading extends CompleteProfileState {}

class UpdateVATNumberSuccess extends CompleteProfileState {}

class UpdateVATNumberFailed extends CompleteProfileState {
  final AlertException exception;

  UpdateVATNumberFailed({required this.exception});
}

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

class UpdateThemesLoading extends CompleteProfileState {}

class UpdateThemesSuccess extends CompleteProfileState {}

class UpdateThemesFailed extends CompleteProfileState {
  final AlertException exception;

  UpdateThemesFailed({required this.exception});
}

/// ---

class UpdateTargetAudienceLoading extends CompleteProfileState {}

class UpdateTargetAudienceSuccess extends CompleteProfileState {}

class UpdateTargetAudienceFailed extends CompleteProfileState {
  final AlertException exception;

  UpdateTargetAudienceFailed({required this.exception});
}

/// ---

class UpdatePortfolioLoading extends CompleteProfileState {}

class UpdatePortfolioSuccess extends CompleteProfileState {}

class UpdatePortfolioFailed extends CompleteProfileState {
  final AlertException exception;

  UpdatePortfolioFailed({required this.exception});
}

/// ---

class UpdateStripeLoading extends CompleteProfileState {}

class StripeUrlFetched extends CompleteProfileState {
  final String url;

  StripeUrlFetched({required this.url});
}

class UpdateStripeSuccess extends CompleteProfileState {}

class UpdateStripeFailed extends CompleteProfileState {
  final AlertException exception;

  UpdateStripeFailed({required this.exception});
}

/// ---

class GetStripeCompletionStatusLoading extends CompleteProfileState {}

class GetStripeCompletionStatusSuccess extends CompleteProfileState {}

class GetStripeCompletionStatusFailed extends CompleteProfileState {
  final AlertException exception;

  GetStripeCompletionStatusFailed({required this.exception});
}

/// ---

class UpdateDocumentFailed extends CompleteProfileState {
  final AlertException exception;

  UpdateDocumentFailed({required this.exception});
}

class UpdateDocumentSuccess extends CompleteProfileState {}
