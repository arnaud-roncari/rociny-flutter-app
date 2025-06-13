import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rociny/core/repositories/company_repository.dart';
import 'package:rociny/core/repositories/crash_repository.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/error_handling/api_exception.dart';
import 'package:rociny/features/company/profile/data/models/company.dart';
import 'package:rociny/features/company/profile/data/models/profile_completion_status.dart';
import 'package:rociny/features/influencer/complete_register/data/enums/platform_type.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required this.crashRepository, required this.companyRepository}) : super(GetProfileLoading()) {
    on<GetProfile>(getProfile);
    on<UpdateProfilePicture>(updateProfilePicture);
    on<UpdateName>(updateName);
    on<UpdateGeolocation>(updateGeolocation);
    on<UpdateDescription>(updateDescription);
    on<AddSocialNetwork>(addSocialNetwork);
    on<UpdateSocialNetwork>(updateSocialNetwork);
    on<DeleteSocialNetwork>(deleteSocialNetwork);
  }
  final CrashRepository crashRepository;
  final CompanyRepository companyRepository;

  ProfileCompletionStatus? profileCompletionStatus;
  late Company company;

  void getProfile(GetProfile event, Emitter<ProfileState> emit) async {
    try {
      emit(GetProfileLoading());

      profileCompletionStatus = await companyRepository.getProfileCompletionStatus();
      company = await companyRepository.getCompany();

      emit(GetProfileSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(GetProfileFailed(exception: alertException));
    }
  }

  void updateProfilePicture(UpdateProfilePicture event, Emitter<ProfileState> emit) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? ximage = await picker.pickImage(source: ImageSource.gallery);
      if (ximage == null) {
        return;
      }
      File image = File(ximage.path);
      await companyRepository.updateProfilePicture(image);
      profileCompletionStatus = await companyRepository.getProfileCompletionStatus();
      company = await companyRepository.getCompany();
      emit(ProfileUpdated());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(UpdateProfilePictureFailed(exception: alertException));
    }
  }

  void updateName(UpdateName event, Emitter<ProfileState> emit) async {
    try {
      emit(UpdateNameLoading());
      await companyRepository.updateName(event.name);
      profileCompletionStatus = await companyRepository.getProfileCompletionStatus();
      company = await companyRepository.getCompany();
      emit(ProfileUpdated());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(UpdateNameFailed(exception: alertException));
    }
  }

  void updateGeolocation(UpdateGeolocation event, Emitter<ProfileState> emit) async {
    try {
      emit(UpdateGeolocationLoading());
      await companyRepository.updateDepartment(event.geolocation);
      profileCompletionStatus = await companyRepository.getProfileCompletionStatus();
      company = await companyRepository.getCompany();
      emit(ProfileUpdated());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(UpdateGeolocationFailed(exception: alertException));
    }
  }

  void updateDescription(UpdateDescription event, Emitter<ProfileState> emit) async {
    try {
      emit(UpdateDescriptionLoading());
      await companyRepository.updateDescription(event.description);
      profileCompletionStatus = await companyRepository.getProfileCompletionStatus();
      company = await companyRepository.getCompany();
      emit(ProfileUpdated());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(UpdateDescriptionFailed(exception: alertException));
    }
  }

  void addSocialNetwork(AddSocialNetwork event, Emitter<ProfileState> emit) async {
    try {
      emit(AddSocialNetworkLoading());
      await companyRepository.addSocialNetwork(event.platform, event.url);
      profileCompletionStatus = await companyRepository.getProfileCompletionStatus();
      company = await companyRepository.getCompany();
      emit(ProfileUpdated());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(AddSocialNetworkFailed(exception: alertException));
    }
  }

  void updateSocialNetwork(UpdateSocialNetwork event, Emitter<ProfileState> emit) async {
    try {
      emit(UpdateSocialNetworkLoading());

      await companyRepository.updateSocialNetwork(event.id, event.url);
      profileCompletionStatus = await companyRepository.getProfileCompletionStatus();
      company = await companyRepository.getCompany();
      emit(ProfileUpdated());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(UpdateSocialNetworkFailed(exception: alertException));
    }
  }

  void deleteSocialNetwork(DeleteSocialNetwork event, Emitter<ProfileState> emit) async {
    try {
      emit(DeleteSocialNetworkSuccess());
      await companyRepository.deleteSocialNetwork(event.id);
      profileCompletionStatus = await companyRepository.getProfileCompletionStatus();
      company = await companyRepository.getCompany();
      emit(ProfileUpdated());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(DeleteSocialNetworkFailed(exception: alertException));
    }
  }
}
