part of 'complete_profile_bloc.dart';

sealed class CompleteProfileEvent {}

class UpdateProfilePicture extends CompleteProfileEvent {}

class UpdateName extends CompleteProfileEvent {
  final String name;

  UpdateName({required this.name});
}

class UpdateDescription extends CompleteProfileEvent {
  final String description;

  UpdateDescription({required this.description});
}

class UpdateDepartment extends CompleteProfileEvent {
  final String department;

  UpdateDepartment({required this.department});
}

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

class GetFacebookSession extends CompleteProfileEvent {}

class GetInstagramAccounts extends CompleteProfileEvent {}

class CreateInstagramAccount extends CompleteProfileEvent {
  final String fetchedInstagramAccountId;

  CreateInstagramAccount({required this.fetchedInstagramAccountId});
}

class UpdateDocument extends CompleteProfileEvent {
  final LegalDocumentType type;

  UpdateDocument({required this.type});
}

class CreateSetupIntent extends CompleteProfileEvent {}
