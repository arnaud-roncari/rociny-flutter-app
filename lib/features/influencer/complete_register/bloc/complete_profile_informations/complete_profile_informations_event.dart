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

class UpdateTargetAudience extends CompleteProfileInformationsEvent {
  final List<String> targetAudience;

  UpdateTargetAudience({required this.targetAudience});
}
