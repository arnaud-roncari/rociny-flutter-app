import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rociny/core/repositories/crash_repository.dart';
import 'package:rociny/core/repositories/influencer_repository.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/error_handling/api_exception.dart';
import 'package:rociny/features/influencer/complete_profile/data/enums/platform_type.dart';
import 'package:rociny/features/influencer/profile/data/models/influencer.dart';
import 'package:rociny/features/influencer/profile/data/models/profile_completion_status.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required this.crashRepository, required this.influencerRepository}) : super(GetProfileLoading()) {
    on<GetProfile>(getProfile);
    on<UpdateProfilePicture>(updateProfilePicture);
    on<UpdateName>(updateName);
    on<UpdateGeolocation>(updateGeolocation);
    on<UpdateDescription>(updateDescription);
    on<AddSocialNetwork>(addSocialNetwork);
    on<UpdateSocialNetwork>(updateSocialNetwork);
    on<DeleteSocialNetwork>(deleteSocialNetwork);
    on<UpdateThemes>(updateThemes);
    on<UpdateTargetAudience>(updateTargetAudience);
    on<AddPicturesToPortfolio>(addPicturesToPortfolio);
    on<RemovePictureFromPortfolio>(removePictureFromPortfolio);
  }
  final CrashRepository crashRepository;
  final InfluencerRepository influencerRepository;

  ProfileCompletionStatus? profileCompletionStatus;
  late Influencer influencer;

  void getProfile(GetProfile event, Emitter<ProfileState> emit) async {
    try {
      emit(GetProfileLoading());

      profileCompletionStatus = await influencerRepository.getProfileCompletionStatus();
      influencer = await influencerRepository.getInfluencer();

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
      await influencerRepository.updateProfilePicture(image);
      profileCompletionStatus = await influencerRepository.getProfileCompletionStatus();
      influencer = await influencerRepository.getInfluencer();
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
      await influencerRepository.updateName(event.name);
      profileCompletionStatus = await influencerRepository.getProfileCompletionStatus();
      influencer = await influencerRepository.getInfluencer();
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
      await influencerRepository.updateDepartment(event.geolocation);
      profileCompletionStatus = await influencerRepository.getProfileCompletionStatus();
      influencer = await influencerRepository.getInfluencer();
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
      await influencerRepository.updateDescription(event.description);
      profileCompletionStatus = await influencerRepository.getProfileCompletionStatus();
      influencer = await influencerRepository.getInfluencer();
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
      await influencerRepository.addSocialNetwork(event.platform, event.url);
      profileCompletionStatus = await influencerRepository.getProfileCompletionStatus();
      influencer = await influencerRepository.getInfluencer();
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

      await influencerRepository.updateSocialNetwork(event.id, event.url);
      profileCompletionStatus = await influencerRepository.getProfileCompletionStatus();
      influencer = await influencerRepository.getInfluencer();
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
      await influencerRepository.deleteSocialNetwork(event.id);
      profileCompletionStatus = await influencerRepository.getProfileCompletionStatus();
      influencer = await influencerRepository.getInfluencer();
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

  void updateThemes(UpdateThemes event, Emitter<ProfileState> emit) async {
    try {
      emit(UpdateThemesLoading());
      await influencerRepository.updateThemes(event.themes);
      profileCompletionStatus = await influencerRepository.getProfileCompletionStatus();
      influencer = await influencerRepository.getInfluencer();
      emit(ProfileUpdated());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(UpdateThemesFailed(exception: alertException));
    }
  }

  void updateTargetAudience(UpdateTargetAudience event, Emitter<ProfileState> emit) async {
    try {
      emit(UpdateTargetAudienceLoading());

      await influencerRepository.updateTargetAudiences(event.targetAudience);
      profileCompletionStatus = await influencerRepository.getProfileCompletionStatus();
      influencer = await influencerRepository.getInfluencer();
      emit(ProfileUpdated());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(UpdateTargetAudienceFailed(exception: alertException));
    }
  }

  void addPicturesToPortfolio(AddPicturesToPortfolio event, Emitter<ProfileState> emit) async {
    try {
      emit(UpdatePortfolioLoading());

      final ImagePicker picker = ImagePicker();
      final List<XFile> ximages = await picker.pickMultiImage(limit: 50);

      List<File> images = ximages.map((xfile) => File(xfile.path)).toList();
      await influencerRepository.addPicturesToPortfolio(images);
      profileCompletionStatus = await influencerRepository.getProfileCompletionStatus();
      influencer = await influencerRepository.getInfluencer();
      emit(UpdatePortfolioSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(UpdatePortfolioFailed(exception: alertException));
    }
  }

  void removePictureFromPortfolio(RemovePictureFromPortfolio event, Emitter<ProfileState> emit) async {
    try {
      emit(UpdatePortfolioLoading());

      await influencerRepository.removePictureFromPortfolio(event.pictureUrl);
      profileCompletionStatus = await influencerRepository.getProfileCompletionStatus();
      influencer = await influencerRepository.getInfluencer();
      emit(UpdatePortfolioSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(UpdatePortfolioFailed(exception: alertException));
    }
  }
}
