part of 'complete_profile_informations_bloc.dart';

sealed class CompleteProfileInformationsEvent {}

class UpdateProfilePicture extends CompleteProfileInformationsEvent {}

class UpdatePortfolio extends CompleteProfileInformationsEvent {}

class UpdateName extends CompleteProfileInformationsEvent {
  final String name;

  UpdateName({required this.name});
}

class UpdateDescription extends CompleteProfileInformationsEvent {
  final String description;

  UpdateDescription({required this.description});
}

class UpdateDepartment extends CompleteProfileInformationsEvent {
  final String department;

  UpdateDepartment({required this.department});
}

class UpdateThemes extends CompleteProfileInformationsEvent {
  final List<String> themes;

  UpdateThemes({required this.themes});
}

class UpdateTargetAudiences extends CompleteProfileInformationsEvent {
  final List<String> targetAudiences;

  UpdateTargetAudiences({required this.targetAudiences});
}

class AddSocialNetwork extends CompleteProfileInformationsEvent {
  final PlatformType platform;
  final String url;

  AddSocialNetwork({required this.platform, required this.url});
}

class DeleteSocialNetwork extends CompleteProfileInformationsEvent {
  final int id;

  DeleteSocialNetwork({required this.id});
}

class UpdateSocialNetwork extends CompleteProfileInformationsEvent {
  final int id;
  final String url;

  UpdateSocialNetwork({required this.id, required this.url});
}
