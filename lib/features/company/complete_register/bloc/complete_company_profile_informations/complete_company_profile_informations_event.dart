part of 'complete_company_profile_informations_bloc.dart';

sealed class CompleteCompanyProfileInformationsEvent {}

class UpdateProfilePicture extends CompleteCompanyProfileInformationsEvent {}

class UpdateName extends CompleteCompanyProfileInformationsEvent {
  final String name;

  UpdateName({required this.name});
}

class UpdateDescription extends CompleteCompanyProfileInformationsEvent {
  final String description;

  UpdateDescription({required this.description});
}

class UpdateDepartment extends CompleteCompanyProfileInformationsEvent {
  final String department;

  UpdateDepartment({required this.department});
}

class AddSocialNetwork extends CompleteCompanyProfileInformationsEvent {
  final PlatformType platform;
  final String url;

  AddSocialNetwork({required this.platform, required this.url});
}

class DeleteSocialNetwork extends CompleteCompanyProfileInformationsEvent {
  final int id;

  DeleteSocialNetwork({required this.id});
}

class UpdateSocialNetwork extends CompleteCompanyProfileInformationsEvent {
  final int id;
  final String url;

  UpdateSocialNetwork({required this.id, required this.url});
}

class GetFacebookSession extends CompleteCompanyProfileInformationsEvent {}

class GetInstagramAccounts extends CompleteCompanyProfileInformationsEvent {}

class CreateInstagramAccount extends CompleteCompanyProfileInformationsEvent {
  final String fetchedInstagramAccountId;

  CreateInstagramAccount({required this.fetchedInstagramAccountId});
}
