import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rociny/core/repositories/crash_repository.dart';
import 'package:rociny/core/repositories/influencer_repository.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/error_handling/api_exception.dart';
import 'package:rociny/features/auth/data/repositories/auth_repository.dart';
import 'package:rociny/features/influencer/complete_profile/data/enums/legal_document_status.dart';
import 'package:rociny/features/influencer/complete_profile/data/enums/legal_document_type.dart';
import 'package:rociny/features/influencer/complete_profile/data/enums/platform_type.dart';
import 'package:rociny/features/influencer/profile/data/models/influencer.dart';

part 'complete_profile_event.dart';
part 'complete_profile_state.dart';

class CompleteProfileBloc extends Bloc<CompleteProfileEvent, CompleteProfileState> {
  CompleteProfileBloc({
    required this.crashRepository,
    required this.influencerRepository,
    required this.authRepository,
  }) : super(CompleteProfileInitial()) {
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
    on<UpdateDocument>(updateDocument);

    on<CreateStripeAccount>(createStripeAccount);
    on<GetStripeAccount>(getStripeAccount);
    on<GetStripeCompletionStatus>(getStripeCompletionStatus);
  }
  final CrashRepository crashRepository;
  final InfluencerRepository influencerRepository;
  final AuthRepository authRepository;

  /// Profile
  late Influencer influencer;

  /// Legal
  LegalDocumentStatus debugStatus = LegalDocumentStatus.missing;
  bool isStripeCompleted = false;

  void getProfile(GetProfile event, Emitter<CompleteProfileState> emit) async {
    try {
      emit(GetProfileLoading());
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

  void updateProfilePicture(UpdateProfilePicture event, Emitter<CompleteProfileState> emit) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? ximage = await picker.pickImage(source: ImageSource.gallery);
      if (ximage == null) {
        return;
      }
      File image = File(ximage.path);
      await influencerRepository.updateProfilePicture(image);

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

  void updateName(UpdateName event, Emitter<CompleteProfileState> emit) async {
    try {
      emit(UpdateNameLoading());
      await influencerRepository.updateName(event.name);
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

  void updateGeolocation(UpdateGeolocation event, Emitter<CompleteProfileState> emit) async {
    try {
      emit(UpdateGeolocationLoading());
      await influencerRepository.updateDepartment(event.geolocation);
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

  void updateDescription(UpdateDescription event, Emitter<CompleteProfileState> emit) async {
    try {
      emit(UpdateDescriptionLoading());
      await influencerRepository.updateDescription(event.description);
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

  void addSocialNetwork(AddSocialNetwork event, Emitter<CompleteProfileState> emit) async {
    try {
      emit(AddSocialNetworkLoading());
      await influencerRepository.addSocialNetwork(event.platform, event.url);
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

  void updateSocialNetwork(UpdateSocialNetwork event, Emitter<CompleteProfileState> emit) async {
    try {
      emit(UpdateSocialNetworkLoading());
      await influencerRepository.updateSocialNetwork(event.id, event.url);
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

  void deleteSocialNetwork(DeleteSocialNetwork event, Emitter<CompleteProfileState> emit) async {
    try {
      emit(DeleteSocialNetworkSuccess());
      await influencerRepository.deleteSocialNetwork(event.id);
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

  void updateThemes(UpdateThemes event, Emitter<CompleteProfileState> emit) async {
    try {
      emit(UpdateThemesLoading());
      await influencerRepository.updateThemes(event.themes);
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

  void updateTargetAudience(UpdateTargetAudience event, Emitter<CompleteProfileState> emit) async {
    try {
      emit(UpdateTargetAudienceLoading());
      await influencerRepository.updateTargetAudiences(event.targetAudience);
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

  void addPicturesToPortfolio(AddPicturesToPortfolio event, Emitter<CompleteProfileState> emit) async {
    try {
      emit(UpdatePortfolioLoading());

      final ImagePicker picker = ImagePicker();
      final List<XFile> ximages = await picker.pickMultiImage(limit: 50);

      List<File> images = ximages.map((xfile) => File(xfile.path)).toList();
      await influencerRepository.addPicturesToPortfolio(images);
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

  void removePictureFromPortfolio(RemovePictureFromPortfolio event, Emitter<CompleteProfileState> emit) async {
    try {
      emit(UpdatePortfolioLoading());
      await influencerRepository.removePictureFromPortfolio(event.pictureUrl);
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

  void updateDocument(UpdateDocument event, Emitter<CompleteProfileState> emit) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result == null) {
        return;
      }
      File pdf = File(result.files.single.path!);

      await influencerRepository.addLegalDocument(event.type, pdf);
      debugStatus = await influencerRepository.getLegalDocumentStatus(event.type);

      emit(ProfileUpdated());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(UpdateDocumentFailed(exception: alertException));
    }
  }

  void createStripeAccount(CreateStripeAccount event, Emitter<CompleteProfileState> emit) async {
    try {
      emit(UpdateStripeLoading());
      String url = await influencerRepository.getStripeAccountUrl();
      emit(StripeUrlFetched(url: url));
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(UpdateStripeFailed(exception: alertException));
    }
  }

  void getStripeAccount(GetStripeAccount event, Emitter<CompleteProfileState> emit) async {
    try {
      emit(UpdateStripeLoading());
      String url = await influencerRepository.getStripeLoginUrl();
      emit(StripeUrlFetched(url: url));
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(UpdateStripeFailed(exception: alertException));
    }
  }

  void getStripeCompletionStatus(GetStripeCompletionStatus event, Emitter<CompleteProfileState> emit) async {
    try {
      emit(GetStripeCompletionStatusLoading());
      isStripeCompleted = await influencerRepository.hasCompletedStripe();
      emit(GetStripeCompletionStatusSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(GetStripeCompletionStatusFailed(exception: alertException));
    }
  }
}
