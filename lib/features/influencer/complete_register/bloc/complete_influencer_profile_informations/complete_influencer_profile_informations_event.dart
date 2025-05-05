part of 'complete_influencer_profile_informations_bloc.dart';

sealed class CompleteInfluencerProfileInformationsEvent {}

class UpdateProfilePicture extends CompleteInfluencerProfileInformationsEvent {}

class UpdatePortfolio extends CompleteInfluencerProfileInformationsEvent {}

class UpdateName extends CompleteInfluencerProfileInformationsEvent {
  final String name;

  UpdateName({required this.name});
}

class UpdateDescription extends CompleteInfluencerProfileInformationsEvent {
  final String description;

  UpdateDescription({required this.description});
}

class UpdateDepartment extends CompleteInfluencerProfileInformationsEvent {
  final String department;

  UpdateDepartment({required this.department});
}

class UpdateThemes extends CompleteInfluencerProfileInformationsEvent {
  final List<String> themes;

  UpdateThemes({required this.themes});
}

class UpdateTargetAudiences extends CompleteInfluencerProfileInformationsEvent {
  final List<String> targetAudiences;

  UpdateTargetAudiences({required this.targetAudiences});
}

class AddSocialNetwork extends CompleteInfluencerProfileInformationsEvent {
  final PlatformType platform;
  final String url;

  AddSocialNetwork({required this.platform, required this.url});
}

class DeleteSocialNetwork extends CompleteInfluencerProfileInformationsEvent {
  final int id;

  DeleteSocialNetwork({required this.id});
}

class UpdateSocialNetwork extends CompleteInfluencerProfileInformationsEvent {
  final int id;
  final String url;

  UpdateSocialNetwork({required this.id, required this.url});
}
