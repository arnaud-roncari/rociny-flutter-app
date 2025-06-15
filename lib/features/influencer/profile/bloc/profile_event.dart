part of 'profile_bloc.dart';

sealed class ProfileEvent {}

class GetProfile extends ProfileEvent {}

/// ---

class UpdateProfilePicture extends ProfileEvent {}

/// ---

class UpdateName extends ProfileEvent {
  final String name;

  UpdateName({required this.name});
}

/// ---

class UpdateGeolocation extends ProfileEvent {
  final String geolocation;

  UpdateGeolocation({required this.geolocation});
}

/// ---

class UpdateDescription extends ProfileEvent {
  final String description;

  UpdateDescription({required this.description});
}

/// ---

class AddSocialNetwork extends ProfileEvent {
  final PlatformType platform;
  final String url;

  AddSocialNetwork({required this.platform, required this.url});
}

class DeleteSocialNetwork extends ProfileEvent {
  final int id;

  DeleteSocialNetwork({required this.id});
}

class UpdateSocialNetwork extends ProfileEvent {
  final int id;
  final String url;

  UpdateSocialNetwork({required this.id, required this.url});
}

/// ---

class UpdateThemes extends ProfileEvent {
  final List<String> themes;

  UpdateThemes({required this.themes});
}

/// ---

class UpdateTargetAudience extends ProfileEvent {
  final List<String> targetAudience;

  UpdateTargetAudience({required this.targetAudience});
}
