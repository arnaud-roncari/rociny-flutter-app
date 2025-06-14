import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rociny/core/repositories/company_repository.dart';
import 'package:rociny/core/repositories/crash_repository.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/error_handling/api_exception.dart';
import 'package:rociny/features/auth/data/repositories/auth_repository.dart';
import 'package:rociny/features/company/complete_profile/data/dtos/setup_intent_dto.dart';
import 'package:rociny/features/company/profile/data/models/company.dart';
import 'package:rociny/features/influencer/complete_register/data/enums/legal_document_status.dart';
import 'package:rociny/features/influencer/complete_register/data/enums/legal_document_type.dart';
import 'package:rociny/features/influencer/complete_register/data/enums/platform_type.dart';

part 'complete_profile_event.dart';
part 'complet_profile_state.dart';

class CompleteProfileBloc extends Bloc<CompleteProfileEvent, CompleteProfileState> {
  CompleteProfileBloc({required this.crashRepository, required this.companyRepository, required this.authRepository})
      : super(GetProfileLoading()) {
    on<GetProfile>(getProfile);
    on<UpdateProfilePicture>(updateProfilePicture);
    on<UpdateName>(updateName);
    on<UpdateGeolocation>(updateGeolocation);
    on<UpdateDescription>(updateDescription);
    on<AddSocialNetwork>(addSocialNetwork);
    on<UpdateSocialNetwork>(updateSocialNetwork);
    on<DeleteSocialNetwork>(deleteSocialNetwork);
    on<UpdateDocument>(updateDocument);
    on<CreateSetupIntent>(createSetupIntent);
  }
  final CrashRepository crashRepository;
  final CompanyRepository companyRepository;
  final AuthRepository authRepository;

  late Company company;

  LegalDocumentStatus debugStatus = LegalDocumentStatus.missing;

  void getProfile(GetProfile event, Emitter<CompleteProfileState> emit) async {
    try {
      emit(GetProfileLoading());
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

  void updateProfilePicture(UpdateProfilePicture event, Emitter<CompleteProfileState> emit) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? ximage = await picker.pickImage(source: ImageSource.gallery);
      if (ximage == null) {
        return;
      }
      File image = File(ximage.path);
      await companyRepository.updateProfilePicture(image);
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

  void updateName(UpdateName event, Emitter<CompleteProfileState> emit) async {
    try {
      emit(UpdateNameLoading());
      await companyRepository.updateName(event.name);
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

  void updateGeolocation(UpdateGeolocation event, Emitter<CompleteProfileState> emit) async {
    try {
      emit(UpdateGeolocationLoading());
      await companyRepository.updateDepartment(event.geolocation);
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

  void updateDescription(UpdateDescription event, Emitter<CompleteProfileState> emit) async {
    try {
      emit(UpdateDescriptionLoading());
      await companyRepository.updateDescription(event.description);
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

  void addSocialNetwork(AddSocialNetwork event, Emitter<CompleteProfileState> emit) async {
    try {
      emit(AddSocialNetworkLoading());
      await companyRepository.addSocialNetwork(event.platform, event.url);
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

  void updateSocialNetwork(UpdateSocialNetwork event, Emitter<CompleteProfileState> emit) async {
    try {
      emit(UpdateSocialNetworkLoading());

      await companyRepository.updateSocialNetwork(event.id, event.url);
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

  void deleteSocialNetwork(DeleteSocialNetwork event, Emitter<CompleteProfileState> emit) async {
    try {
      emit(DeleteSocialNetworkSuccess());
      await companyRepository.deleteSocialNetwork(event.id);
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

      await companyRepository.addLegalDocument(event.type, pdf);
      debugStatus = await companyRepository.getLegalDocumentStatus(event.type);

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

  void createSetupIntent(CreateSetupIntent event, Emitter<CompleteProfileState> emit) async {
    try {
      emit(CreateSetupIntentLoading());

      SetupIntentDto si = await companyRepository.createSetupIntent();
      String customerId = si.customerId;
      String ephemeralKeySecret = si.ephemeralKeySecret;
      String setupIntentSecret = si.setupIntentSecret;

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: false,
          merchantDisplayName: 'Rociny',
          setupIntentClientSecret: setupIntentSecret,
          customerEphemeralKeySecret: ephemeralKeySecret,
          customerId: customerId,
        ),
      );
      await Stripe.instance.presentPaymentSheet();
      emit(ProfileUpdated());
    } catch (exception, stack) {
      if (exception is StripeException) {
        return;
      }
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }
      AlertException alertException = AlertException.fromException(exception);
      emit(CreateSetupIntentFailed(exception: alertException));
    }
  }
}
