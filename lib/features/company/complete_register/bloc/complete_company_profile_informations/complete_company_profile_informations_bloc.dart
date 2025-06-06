import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rociny/core/repositories/company_repository.dart';
import 'package:rociny/core/repositories/crash_repository.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/error_handling/api_exception.dart';
import 'package:rociny/features/auth/data/models/fetched_instagram_account.dart';
import 'package:rociny/features/auth/data/models/instagram_account.dart';
import 'package:rociny/features/auth/data/repositories/auth_repository.dart';
import 'package:rociny/features/influencer/complete_register/data/enums/platform_type.dart';
import 'package:rociny/features/influencer/complete_register/data/models/social_network_model.dart';

part 'complete_company_profile_informations_event.dart';
part 'complete_company_profile_informations_state.dart';

class CompleteCompanyProfileInformationsBloc
    extends Bloc<CompleteCompanyProfileInformationsEvent, CompleteCompanyProfileInformationsState> {
  CompleteCompanyProfileInformationsBloc(
      {required this.crashRepository, required this.companyRepository, required this.authRepository})
      : super(CompleteProfileInitial()) {
    on<UpdateProfilePicture>(updateProfilePicture);
    on<UpdateName>(updateName);
    on<UpdateDescription>(updateDescription);
    on<UpdateDepartment>(updateDepartment);
    on<AddSocialNetwork>(addSocialNetwork);
    on<UpdateSocialNetwork>(updateSocialNetwork);
    on<DeleteSocialNetwork>(deleteSocialNetwork);
    on<GetFacebookSession>(getFacebookSession);
    on<GetInstagramAccounts>(getInstagramAccounts);
    on<CreateInstagramAccount>(createInstagramAccount);
  }
  final CrashRepository crashRepository;
  final CompanyRepository companyRepository;
  final AuthRepository authRepository;

  String? profilePicture;
  String? name;
  String? description;
  String? department;
  List<SocialNetwork> socialNetworks = [];

  bool hasFacebookSession = false;
  late List<FetchedInstagramAccount> instagramAccounts;
  InstagramAccount? instagramAccount;
  bool hasInstagramAccount = false;

  void updateProfilePicture(UpdateProfilePicture event, Emitter<CompleteCompanyProfileInformationsState> emit) async {
    try {
      final ImagePicker picker = ImagePicker();

      final XFile? ximage = await picker.pickImage(source: ImageSource.gallery);
      if (ximage == null) {
        return;
      }
      File image = File(ximage.path);
      profilePicture = await companyRepository.updateProfilePicture(image);
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

  void updateName(UpdateName event, Emitter<CompleteCompanyProfileInformationsState> emit) async {
    try {
      name = event.name;
      await companyRepository.updateName(name!);
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

  void updateDescription(UpdateDescription event, Emitter<CompleteCompanyProfileInformationsState> emit) async {
    try {
      description = event.description;
      await companyRepository.updateDescription(description!);
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

  void updateDepartment(UpdateDepartment event, Emitter<CompleteCompanyProfileInformationsState> emit) async {
    try {
      department = event.department;
      await companyRepository.updateDepartment(department!);
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

  void addSocialNetwork(AddSocialNetwork event, Emitter<CompleteCompanyProfileInformationsState> emit) async {
    try {
      await companyRepository.addSocialNetwork(event.platform, event.url);
      socialNetworks = await companyRepository.getSocialNetworks();
      emit(AddSocialNetworkSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(AddSocialNetworkFailed(exception: alertException));
    }
  }

  void updateSocialNetwork(UpdateSocialNetwork event, Emitter<CompleteCompanyProfileInformationsState> emit) async {
    try {
      await companyRepository.updateSocialNetwork(event.id, event.url);
      socialNetworks = await companyRepository.getSocialNetworks();
      emit(UpdateSocialNetworkSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(UpdateSocialNetworkFailed(exception: alertException));
    }
  }

  void deleteSocialNetwork(DeleteSocialNetwork event, Emitter<CompleteCompanyProfileInformationsState> emit) async {
    try {
      await companyRepository.deleteSocialNetwork(event.id);
      socialNetworks = await companyRepository.getSocialNetworks();
      emit(DeleteSocialNetworkSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(DeleteSocialNetworkFailed(exception: alertException));
    }
  }

  void getFacebookSession(GetFacebookSession event, Emitter<CompleteCompanyProfileInformationsState> emit) async {
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

  void getInstagramAccounts(GetInstagramAccounts event, Emitter<CompleteCompanyProfileInformationsState> emit) async {
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

  void createInstagramAccount(
      CreateInstagramAccount event, Emitter<CompleteCompanyProfileInformationsState> emit) async {
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
}
