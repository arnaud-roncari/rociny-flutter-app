import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/constants/storage_keys.dart';
import 'package:rociny/core/repositories/company_repository.dart';
import 'package:rociny/core/repositories/crash_repository.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/error_handling/api_exception.dart';
import 'package:rociny/features/auth/data/models/fetched_instagram_account.dart';
import 'package:rociny/features/auth/data/models/instagram_account.dart';
import 'package:rociny/features/auth/data/repositories/auth_repository.dart';
import 'package:rociny/features/company/complete_profile/data/dtos/setup_intent_dto.dart';
import 'package:rociny/features/influencer/complete_register/data/enums/legal_document_status.dart';
import 'package:rociny/features/influencer/complete_register/data/enums/legal_document_type.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({required this.crashRepository, required this.companyRepository, required this.authRepository})
      : super(SettingsInitial()) {
    on<GetIsRegisteredLocally>(getIsRegisteredLocally);
    on<UpdatePassword>(updatePassword);
    on<UpdateEmail>(updateEmail);
    on<VerifyUpdateEmail>(verifyUpdateEmail);
    on<OnResentUpdateEmailVerificationCode>(resentUpdateEmailVerificationCode);
    on<OnLogout>(logout);
    on<OnDeleteAccount>(deleteAccount);
    on<GetCompanySectionsStatus>(getCompanySectionsStatus);
    on<UpdateLegalDocument>(updateLegalDocument);
    on<GetLegalDocumentsStatus>(getLegalDocumentsStatus);
    on<CreateSetupIntent>(createSetupIntent);
    on<GetFacebookSession>(getFacebookSession);
    on<GetInstagramAccounts>(getInstagramAccounts);
    on<CreateInstagramAccount>(createInstagramAccount);
    on<LogoutFacebook>(logoutFacebook);
  }
  final CrashRepository crashRepository;
  final CompanyRepository companyRepository;
  final AuthRepository authRepository;

  bool? isRegisteredLocally;
  String? newEmail;
  late bool hasCompletedStripe;
  late bool hasCompletedLegalDocuments;

  late LegalDocumentStatus debugStatus;

  String? stripeBillingPortalSessionUrl;

  bool hasFacebookSession = false;
  late List<FetchedInstagramAccount> instagramAccounts;
  InstagramAccount? instagramAccount;
  bool hasInstagramAccount = false;

  void getIsRegisteredLocally(GetIsRegisteredLocally event, Emitter<SettingsState> emit) async {
    try {
      emit(GetIsRegisteredLocallyLoading());

      isRegisteredLocally = await authRepository.isRegisteredLocally();
      emit(GetIsRegisteredLocallySuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(GetIsRegisteredLocallyFailed(exception: alertException));
    }
  }

  void updatePassword(UpdatePassword event, Emitter<SettingsState> emit) async {
    try {
      emit(UpdatePasswordLoading());

      await authRepository.updatePassword(event.password, event.newPassword);
      kJwt = null;
      FlutterSecureStorage storage = const FlutterSecureStorage();
      await storage.delete(key: kKeyJwt);
      emit(UpdatePasswordSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(UpdatePasswordFailed(exception: alertException));
    }
  }

  void updateEmail(UpdateEmail event, Emitter<SettingsState> emit) async {
    try {
      emit(UpdateEmailLoading());

      newEmail = event.newEmail;
      await authRepository.updateEmail(newEmail!, event.password);

      emit(UpdateEmailSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      } else if (exception.id == 'security:user:already_updating_email') {
        emit(UpdateEmailSuccess());
        return;
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(UpdateEmailFailed(exception: alertException));
    }
  }

  void logout(OnLogout event, Emitter<SettingsState> emit) async {
    kJwt = null;
    FlutterSecureStorage storage = const FlutterSecureStorage();
    await storage.delete(key: kKeyJwt);
  }

  void deleteAccount(OnDeleteAccount event, Emitter<SettingsState> emit) async {
    await authRepository.deleteAccount();
    kJwt = null;
    FlutterSecureStorage storage = const FlutterSecureStorage();
    await storage.delete(key: kKeyJwt);
  }

  void verifyUpdateEmail(VerifyUpdateEmail event, Emitter<SettingsState> emit) async {
    try {
      await authRepository.verifyUpdateEmailCode(newEmail!, event.code);
      kJwt = null;
      FlutterSecureStorage storage = const FlutterSecureStorage();
      await storage.delete(key: kKeyJwt);
      emit(VerifyUpdateEmailSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(VerifyUpdateEmailFailed(exception: alertException));
    }
  }

  void resentUpdateEmailVerificationCode(OnResentUpdateEmailVerificationCode event, Emitter<SettingsState> emit) async {
    try {
      await authRepository.resentUpdateEmailVerificationCode(newEmail!);
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(ResentUpdateEmailVerificationCodeFailed(exception: alertException));
    }
  }

  void getCompanySectionsStatus(GetCompanySectionsStatus event, Emitter<SettingsState> emit) async {
    try {
      emit(GetCompanySectionsStatusLoading());

      hasCompletedLegalDocuments = await companyRepository.hasCompletedLegalDocuments();
      hasCompletedStripe = await companyRepository.hasCompletedStripe();

      emit(GetCompanySectionsStatusSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(GetCompanySectionsStatusFailed(exception: alertException));
    }
  }

  void updateLegalDocument(UpdateLegalDocument event, Emitter<SettingsState> emit) async {
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
      emit(UpdateLegalDocumentSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(UpdateLegalDocumentFailed(exception: alertException));
    }
  }

  void getLegalDocumentsStatus(GetLegalDocumentsStatus event, Emitter<SettingsState> emit) async {
    try {
      emit(GetLegalDocumentsStatusLoading());

      debugStatus = await companyRepository.getLegalDocumentStatus(LegalDocumentType.debug);
      emit(GetLegalDocumentsStatusSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(GetLegalDocumentsStatusFailed(exception: alertException));
    }
  }

  void createSetupIntent(CreateSetupIntent event, Emitter<SettingsState> emit) async {
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
      emit(CreateSetupIntentSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(CreateSetupIntentFailed(exception: alertException));
    }
  }

  void getFacebookSession(GetFacebookSession event, Emitter<SettingsState> emit) async {
    try {
      emit(GetFacebookSessionLoading());
      hasFacebookSession = await authRepository.hasFacebookSession();

      if (hasFacebookSession) {
        hasInstagramAccount = await companyRepository.hasInstagramAccount();
        if (hasInstagramAccount) {
          instagramAccount = await companyRepository.getInstagramAccount();
        }
      }

      emit(GetFacebookSessionSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      AlertException alertException = AlertException.fromException(exception);
      emit(GetFacebookSessionFailed(exception: alertException));
    }
  }

  void getInstagramAccounts(GetInstagramAccounts event, Emitter<SettingsState> emit) async {
    try {
      emit(GetInstagramAccountsLoading());
      instagramAccounts = await authRepository.getInstagramAccounts();
      emit(GetInstagramAccountsSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      AlertException alertException = AlertException.fromException(exception);
      emit(GetInstagramAccountsFailed(exception: alertException));
    }
  }

  void createInstagramAccount(CreateInstagramAccount event, Emitter<SettingsState> emit) async {
    try {
      emit(CreateInstagramAccountLoading());
      await companyRepository.createInstagramAccount(event.fetchedInstagramAccountId);
      instagramAccount = await companyRepository.getInstagramAccount();
      hasInstagramAccount = true;
      emit(CreateInstagramAccountSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      AlertException alertException = AlertException.fromException(exception);
      emit(CreateInstagramAccountFailed(exception: alertException));
    }
  }

  void logoutFacebook(LogoutFacebook event, Emitter<SettingsState> emit) async {
    try {
      emit(LogoutFacebookLoading());
      hasFacebookSession = false;
      instagramAccount = null;
      hasInstagramAccount = false;
      await authRepository.logoutFacebook();
      emit(LogoutFacebookSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      AlertException alertException = AlertException.fromException(exception);
      emit(LogoutFacebookFailed(exception: alertException));
    }
  }
}
