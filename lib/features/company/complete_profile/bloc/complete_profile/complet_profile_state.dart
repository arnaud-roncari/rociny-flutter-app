part of 'complete_profile_bloc.dart';

sealed class CompleteProfileState {}

class CompleteProfileInitial extends CompleteProfileState {}

class UpdateProfilePictureFailed extends CompleteProfileState {
  final AlertException exception;

  UpdateProfilePictureFailed({required this.exception});
}

class UpdateProfilePictureSuccess extends CompleteProfileState {}

class UpdateNameFailed extends CompleteProfileState {
  final AlertException exception;

  UpdateNameFailed({required this.exception});
}

class UpdateNameSuccess extends CompleteProfileState {}

class UpdateDescriptionFailed extends CompleteProfileState {
  final AlertException exception;

  UpdateDescriptionFailed({required this.exception});
}

class UpdateDescriptionSuccess extends CompleteProfileState {}

class UpdateDepartmentFailed extends CompleteProfileState {
  final AlertException exception;

  UpdateDepartmentFailed({required this.exception});
}

class UpdateDepartmentSuccess extends CompleteProfileState {}

class AddSocialNetworkFailed extends CompleteProfileState {
  final AlertException exception;

  AddSocialNetworkFailed({required this.exception});
}

class AddSocialNetworkSuccess extends CompleteProfileState {}

class DeleteSocialNetworkFailed extends CompleteProfileState {
  final AlertException exception;

  DeleteSocialNetworkFailed({required this.exception});
}

class DeleteSocialNetworkSuccess extends CompleteProfileState {}

class UpdateSocialNetworkFailed extends CompleteProfileState {
  final AlertException exception;

  UpdateSocialNetworkFailed({required this.exception});
}

class UpdateSocialNetworkSuccess extends CompleteProfileState {}

// ---

class GetFacebookSessionLoading extends CompleteProfileState {}

class GetFacebookSessionSuccess extends CompleteProfileState {}

class GetFacebookSessionFailed extends CompleteProfileState {
  final AlertException exception;

  GetFacebookSessionFailed({required this.exception});
}

/// ---

class GetInstagramAccountsLoading extends CompleteProfileState {}

class GetInstagramAccountsSuccess extends CompleteProfileState {}

class GetInstagramAccountsFailed extends CompleteProfileState {
  final AlertException exception;

  GetInstagramAccountsFailed({required this.exception});
}

/// ---

class CreateInstagramAccountLoading extends CompleteProfileState {}

class CreateInstagramAccountSuccess extends CompleteProfileState {}

class CreateInstagramAccountFailed extends CompleteProfileState {
  final AlertException exception;

  CreateInstagramAccountFailed({required this.exception});
}

/// ---

class CompleteLegalInitial extends CompleteProfileState {}

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
