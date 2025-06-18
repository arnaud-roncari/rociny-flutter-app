import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rociny/core/repositories/crash_repository.dart';
import 'package:rociny/core/repositories/influencer_repository.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/error_handling/api_exception.dart';
import 'package:rociny/features/influencer/complete_profile/data/enums/legal_document_status.dart';
import 'package:rociny/features/influencer/complete_profile/data/enums/legal_document_type.dart';
import 'package:file_picker/file_picker.dart';

part 'complete_influencer_legal_informations_event.dart';
part 'complete_influencer_legal_informations_state.dart';

class CompleteInfluencerLegalInformationsBloc
    extends Bloc<CompleteInfluencerLegalInformationsEvent, CompleteInfluencerLegalInformationsState> {
  CompleteInfluencerLegalInformationsBloc({required this.crashRepository, required this.influencerRepository})
      : super(CompleteLegalInitial()) {
    on<UpdateDocument>(updateDocument);
    on<GetStripeAccountLink>(getStripeAccountLink);
    on<GetStripeLoginLink>(getStripeLoginLink);
    on<SetStripeAccountStatus>(setStripeAccountStatus);
  }
  final CrashRepository crashRepository;
  final InfluencerRepository influencerRepository;

  /// Documents status (add more)
  LegalDocumentStatus debugStatus = LegalDocumentStatus.missing;

  /// Stripe webview url
  String? stripeAccountUrl;
  String? stripeLoginUrl;

  /// Stripe account status
  bool hasCompletedStripe = false;

  void updateDocument(UpdateDocument event, Emitter<CompleteInfluencerLegalInformationsState> emit) async {
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
      emit(UpdateDocumentSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(UpdateDocumentFailed(exception: alertException));
    }
  }

  void getStripeAccountLink(GetStripeAccountLink event, Emitter<CompleteInfluencerLegalInformationsState> emit) async {
    try {
      emit(GetStripeAccountLinkLoading());

      stripeAccountUrl = await influencerRepository.getStripeAccountUrl();
      emit(GetStripeAccountLinkSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(GetStripeAccountLinkFailed(exception: alertException));
    }
  }

  void getStripeLoginLink(GetStripeLoginLink event, Emitter<CompleteInfluencerLegalInformationsState> emit) async {
    try {
      emit(GetStripeLoginLinkLoading());

      stripeLoginUrl = await influencerRepository.getStripeLoginUrl();
      emit(GetStripeLoginLinkSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(GetStripeLoginLinkFailed(exception: alertException));
    }
  }

  void setStripeAccountStatus(
      SetStripeAccountStatus event, Emitter<CompleteInfluencerLegalInformationsState> emit) async {
    hasCompletedStripe = true;
    emit(StripeAccountCompleted());
  }
}
