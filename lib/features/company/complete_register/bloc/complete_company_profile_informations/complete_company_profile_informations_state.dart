part of 'complete_company_profile_informations_bloc.dart';

sealed class CompleteCompanyProfileInformationsState {}

class CompleteProfileInitial extends CompleteCompanyProfileInformationsState {}

class UpdateProfilePictureFailed extends CompleteCompanyProfileInformationsState {
  final AlertException exception;

  UpdateProfilePictureFailed({required this.exception});
}

class UpdateProfilePictureSuccess extends CompleteCompanyProfileInformationsState {}

class UpdateNameFailed extends CompleteCompanyProfileInformationsState {
  final AlertException exception;

  UpdateNameFailed({required this.exception});
}

class UpdateNameSuccess extends CompleteCompanyProfileInformationsState {}

class UpdateDescriptionFailed extends CompleteCompanyProfileInformationsState {
  final AlertException exception;

  UpdateDescriptionFailed({required this.exception});
}

class UpdateDescriptionSuccess extends CompleteCompanyProfileInformationsState {}

class UpdateDepartmentFailed extends CompleteCompanyProfileInformationsState {
  final AlertException exception;

  UpdateDepartmentFailed({required this.exception});
}

class UpdateDepartmentSuccess extends CompleteCompanyProfileInformationsState {}

class AddSocialNetworkFailed extends CompleteCompanyProfileInformationsState {
  final AlertException exception;

  AddSocialNetworkFailed({required this.exception});
}

class AddSocialNetworkSuccess extends CompleteCompanyProfileInformationsState {}

class DeleteSocialNetworkFailed extends CompleteCompanyProfileInformationsState {
  final AlertException exception;

  DeleteSocialNetworkFailed({required this.exception});
}

class DeleteSocialNetworkSuccess extends CompleteCompanyProfileInformationsState {}

class UpdateSocialNetworkFailed extends CompleteCompanyProfileInformationsState {
  final AlertException exception;

  UpdateSocialNetworkFailed({required this.exception});
}

class UpdateSocialNetworkSuccess extends CompleteCompanyProfileInformationsState {}

// ---

class GetFacebookSessionLoading extends CompleteCompanyProfileInformationsState {}

class GetFacebookSessionSuccess extends CompleteCompanyProfileInformationsState {}

class GetFacebookSessionFailed extends CompleteCompanyProfileInformationsState {
  final AlertException exception;

  GetFacebookSessionFailed({required this.exception});
}

/// ---

class GetInstagramAccountsLoading extends CompleteCompanyProfileInformationsState {}

class GetInstagramAccountsSuccess extends CompleteCompanyProfileInformationsState {}

class GetInstagramAccountsFailed extends CompleteCompanyProfileInformationsState {
  final AlertException exception;

  GetInstagramAccountsFailed({required this.exception});
}

/// ---

class CreateInstagramAccountLoading extends CompleteCompanyProfileInformationsState {}

class CreateInstagramAccountSuccess extends CompleteCompanyProfileInformationsState {}

class CreateInstagramAccountFailed extends CompleteCompanyProfileInformationsState {
  final AlertException exception;

  CreateInstagramAccountFailed({required this.exception});
}
