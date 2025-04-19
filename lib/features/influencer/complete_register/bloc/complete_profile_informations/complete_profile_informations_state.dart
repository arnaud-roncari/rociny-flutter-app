part of 'complete_profile_informations_bloc.dart';

sealed class CompleteProfileInformationsState {}

class CompleteProfileInitial extends CompleteProfileInformationsState {}

class UpdateProfilePictureFailed extends CompleteProfileInformationsState {
  final AlertException exception;

  UpdateProfilePictureFailed({required this.exception});
}

class UpdateProfilePictureSuccess extends CompleteProfileInformationsState {}

class UpdatePortfolioFailed extends CompleteProfileInformationsState {
  final AlertException exception;

  UpdatePortfolioFailed({required this.exception});
}

class UpdatePortfolioSuccess extends CompleteProfileInformationsState {}

class UpdateNameFailed extends CompleteProfileInformationsState {
  final AlertException exception;

  UpdateNameFailed({required this.exception});
}

class UpdateNameSuccess extends CompleteProfileInformationsState {}

class UpdateDescriptionFailed extends CompleteProfileInformationsState {
  final AlertException exception;

  UpdateDescriptionFailed({required this.exception});
}

class UpdateDescriptionSuccess extends CompleteProfileInformationsState {}

class UpdateDepartmentFailed extends CompleteProfileInformationsState {
  final AlertException exception;

  UpdateDepartmentFailed({required this.exception});
}

class UpdateDepartmentSuccess extends CompleteProfileInformationsState {}

class UpdateThemesFailed extends CompleteProfileInformationsState {
  final AlertException exception;

  UpdateThemesFailed({required this.exception});
}

class UpdateThemesSuccess extends CompleteProfileInformationsState {}

class UpdateTargetAudienceFailed extends CompleteProfileInformationsState {
  final AlertException exception;

  UpdateTargetAudienceFailed({required this.exception});
}

class UpdateTargetAudienceSuccess extends CompleteProfileInformationsState {}
