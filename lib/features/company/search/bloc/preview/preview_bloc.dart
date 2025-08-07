import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rociny/core/repositories/company_repository.dart';
import 'package:rociny/core/repositories/crash_repository.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/error_handling/api_exception.dart';
import 'package:rociny/features/auth/data/models/instagram_account.dart';
import 'package:rociny/features/company/profile/data/models/company.dart';
import 'package:rociny/features/company/profile/data/models/profile_completion_status.dart';
import 'package:rociny/features/company/search/data/enums/product_placement_type.dart';
import 'package:rociny/features/company/search/data/models/collaboration_model.dart';
import 'package:rociny/features/company/search/data/models/product_placement_model.dart';
import 'package:rociny/features/influencer/profile/data/models/influencer.dart';
import 'package:rociny/features/influencer/profile/data/models/profile_completion_status.dart' as i;

part 'preview_event.dart';
part 'preview_state.dart';

class PreviewBloc extends Bloc<PreviewEvent, PreviewState> {
  PreviewBloc({
    required this.crashRepository,
    required this.companyRepository,
  }) : super(InitializeLoading()) {
    on<Initialize>(initialize);
    on<UpdateStep>(updateStep);
    on<CreateProductPlacement>(createProductPlacement);
    on<RemoveProductPlacement>(removeProductPlacement);
    on<PickFiles>(pickFiles);
    on<RemoveFile>(removeFile);
    on<CreateCollaboration>(createCollaboration);
    on<GetProductPlacementPrice>(getProductPlacementPrice);
  }
  final CrashRepository crashRepository;
  final CompanyRepository companyRepository;

  /// Influencer
  late i.ProfileCompletionStatus influencerProfileCompletion;
  late Influencer influencer;
  InstagramAccount? instagramAccount;

  /// Company
  late ProfileCompletionStatus companyProfileCompletion;
  late Company company;

  /// Collaboration
  late Collaboration collaboration;
  late List<File> files;

  int? suggestedPrice;

  void initialize(Initialize event, Emitter<PreviewState> emit) async {
    try {
      emit(InitializeLoading());

      /// Set an empty collaboration, to be fill with the forms.
      collaboration = Collaboration.empty();
      files = [];

      /// TODO optimise requete en simlatné
      influencerProfileCompletion = await companyRepository.getInfluencerCompletionStatus(event.userId);
      influencer = await companyRepository.getInfluencer(event.userId);
      if (influencerProfileCompletion.hasInstagramAccount) {
        instagramAccount = await companyRepository.getInfluencerInstagramAccount(event.userId);
      }

      companyProfileCompletion = await companyRepository.getProfileCompletionStatus();
      company = await companyRepository.getCompany();

      collaboration.influencerId = influencer.id;

      emit(InitializeSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(InitializeFailed(exception: alertException));
    }
  }

  void updateStep(UpdateStep event, Emitter<PreviewState> emit) async {
    emit(StepUpdated(index: event.index));
  }

  void createProductPlacement(CreateProductPlacement event, Emitter<PreviewState> emit) async {
    collaboration.productPlacements.add(event.productPlacement);
    emit(ProductPlacementCreated());
  }

  void removeProductPlacement(RemoveProductPlacement event, Emitter<PreviewState> emit) async {
    collaboration.productPlacements.removeWhere((p) => p.isSameAs(event.productPlacement));
    emit(ProductPlacementRemoved());
  }

  void pickFiles(PickFiles event, Emitter<PreviewState> emit) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null) {
      return;
    }
    List<File> newFiles = result.files.where((f) => f.path != null).map((f) => File(f.path!)).toList();
    files.addAll(newFiles);
    emit(FilesUpdated());
  }

  void removeFile(RemoveFile event, Emitter<PreviewState> emit) async {
    files.removeWhere((f) => f.path == event.file.path);
    emit(FilesUpdated());
  }

  void createCollaboration(CreateCollaboration event, Emitter<PreviewState> emit) async {
    try {
      emit(CreateCollaborationLoading());
      late Collaboration c;
      if (event.isDraft) {
        c = await companyRepository.createDraftCollaboration(collaboration);
      } else {
        c = await companyRepository.createCollaboration(collaboration);
      }
      await companyRepository.uploadCollaborationFiles(c.id, files);

      emit(CreateCollaborationSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(CreateCollaborationFailed(exception: alertException));
    }
  }

  void getProductPlacementPrice(GetProductPlacementPrice event, Emitter<PreviewState> emit) async {
    try {
      emit(GetProductPlacementPriceLoading());
      suggestedPrice = await companyRepository.calculateProductPlacementPrice(influencer.userId, event.type);
      emit(GetProductPlacementPriceSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(GetProductPlacementPriceFailed(exception: alertException));
    }
  }
}
