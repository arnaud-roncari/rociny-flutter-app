import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rociny/core/repositories/crash_repository.dart';
import 'package:rociny/core/repositories/influencer_repository.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/error_handling/api_exception.dart';

part 'complete_profile_informations_event.dart';
part 'complete_profile_informations_state.dart';

class CompleteProfileInformationsBloc extends Bloc<CompleteProfileInformationsEvent, CompleteProfileInformationsState> {
  CompleteProfileInformationsBloc({required this.crashRepository, required this.influencerRepository})
      : super(CompleteProfileInitial()) {
    on<UpdateProfilePicture>(updateProfilePicture);
    on<UpdatePortfolio>(updatePortfolio);
    on<UpdateName>(updateName);
    on<UpdateDescription>(updateDescription);
    on<UpdateDepartment>(updateDepartment);
    on<UpdateThemes>(updateThemes);
    on<UpdateTargetAudiences>(updateTargetAudiences);
  }
  final CrashRepository crashRepository;
  final InfluencerRepository influencerRepository;

  String? profilePicture;
  List<String> portfolio = [];
  String? name;
  String? description;
  String? department;
  List<String>? themes;
  List<String>? targetAudiences;

  void updateProfilePicture(UpdateProfilePicture event, Emitter<CompleteProfileInformationsState> emit) async {
    try {
      final ImagePicker picker = ImagePicker();

      final XFile? ximage = await picker.pickImage(source: ImageSource.gallery);
      if (ximage == null) {
        return;
      }
      File image = File(ximage.path);
      profilePicture = await influencerRepository.updateProfilePicture(image);
      emit(UpdateProfilePictureSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(UpdateProfilePictureFailed(exception: alertException));
    }
  }

  void updatePortfolio(UpdatePortfolio event, Emitter<CompleteProfileInformationsState> emit) async {
    try {
      final ImagePicker picker = ImagePicker();

      final List<XFile> ximages = await picker.pickMultiImage(limit: 5);

      List<File> images = ximages.map((xfile) => File(xfile.path)).toList();
      portfolio = await influencerRepository.updatePortfolio(images);
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

  void updateName(UpdateName event, Emitter<CompleteProfileInformationsState> emit) async {
    try {
      name = event.name;
      await influencerRepository.updateName(name!);
      emit(UpdateNameSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(UpdateNameFailed(exception: alertException));
    }
  }

  void updateDescription(UpdateDescription event, Emitter<CompleteProfileInformationsState> emit) async {
    try {
      description = event.description;
      await influencerRepository.updateDescription(description!);
      emit(UpdateDescriptionSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(UpdateDescriptionFailed(exception: alertException));
    }
  }

  void updateDepartment(UpdateDepartment event, Emitter<CompleteProfileInformationsState> emit) async {
    try {
      department = event.department;
      await influencerRepository.updateDepartment(department!);
      emit(UpdateDepartmentSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(UpdateDepartmentFailed(exception: alertException));
    }
  }

  void updateThemes(UpdateThemes event, Emitter<CompleteProfileInformationsState> emit) async {
    try {
      themes = event.themes;
      await influencerRepository.updateThemes(themes!);
      emit(UpdateThemesSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(UpdateThemesFailed(exception: alertException));
    }
  }

  void updateTargetAudiences(UpdateTargetAudiences event, Emitter<CompleteProfileInformationsState> emit) async {
    try {
      targetAudiences = event.targetAudiences;
      await influencerRepository.updateTargetAudiences(targetAudiences!);
      emit(UpdateTargetAudiencesSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(UpdateTargetAudiencesFailed(exception: alertException));
    }
  }
}
