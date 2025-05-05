part of 'complete_influencer_profile_informations_bloc.dart';

sealed class CompleteInfluencerProfileInformationsState {}

class CompleteProfileInitial extends CompleteInfluencerProfileInformationsState {}

class UpdateProfilePictureFailed extends CompleteInfluencerProfileInformationsState {
  final AlertException exception;

  UpdateProfilePictureFailed({required this.exception});
}

class UpdateProfilePictureSuccess extends CompleteInfluencerProfileInformationsState {}

class UpdatePortfolioFailed extends CompleteInfluencerProfileInformationsState {
  final AlertException exception;

  UpdatePortfolioFailed({required this.exception});
}

class UpdatePortfolioSuccess extends CompleteInfluencerProfileInformationsState {}

class UpdateNameFailed extends CompleteInfluencerProfileInformationsState {
  final AlertException exception;

  UpdateNameFailed({required this.exception});
}

class UpdateNameSuccess extends CompleteInfluencerProfileInformationsState {}

class UpdateDescriptionFailed extends CompleteInfluencerProfileInformationsState {
  final AlertException exception;

  UpdateDescriptionFailed({required this.exception});
}

class UpdateDescriptionSuccess extends CompleteInfluencerProfileInformationsState {}

class UpdateDepartmentFailed extends CompleteInfluencerProfileInformationsState {
  final AlertException exception;

  UpdateDepartmentFailed({required this.exception});
}

class UpdateDepartmentSuccess extends CompleteInfluencerProfileInformationsState {}

class UpdateThemesFailed extends CompleteInfluencerProfileInformationsState {
  final AlertException exception;

  UpdateThemesFailed({required this.exception});
}

class UpdateThemesSuccess extends CompleteInfluencerProfileInformationsState {}

class UpdateTargetAudiencesFailed extends CompleteInfluencerProfileInformationsState {
  final AlertException exception;

  UpdateTargetAudiencesFailed({required this.exception});
}

class UpdateTargetAudiencesSuccess extends CompleteInfluencerProfileInformationsState {}

class AddSocialNetworkFailed extends CompleteInfluencerProfileInformationsState {
  final AlertException exception;

  AddSocialNetworkFailed({required this.exception});
}

class AddSocialNetworkSuccess extends CompleteInfluencerProfileInformationsState {}

class DeleteSocialNetworkFailed extends CompleteInfluencerProfileInformationsState {
  final AlertException exception;

  DeleteSocialNetworkFailed({required this.exception});
}

class DeleteSocialNetworkSuccess extends CompleteInfluencerProfileInformationsState {}

class UpdateSocialNetworkFailed extends CompleteInfluencerProfileInformationsState {
  final AlertException exception;

  UpdateSocialNetworkFailed({required this.exception});
}

class UpdateSocialNetworkSuccess extends CompleteInfluencerProfileInformationsState {}
