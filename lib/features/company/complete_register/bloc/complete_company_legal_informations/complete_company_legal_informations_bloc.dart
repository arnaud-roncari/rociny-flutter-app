import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:rociny/core/repositories/company_repository.dart';
import 'package:rociny/core/repositories/crash_repository.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/error_handling/api_exception.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/company/complete_register/data/dtos/setup_intent_dto.dart';
import 'package:rociny/features/influencer/complete_register/data/enums/legal_document_status.dart';
import 'package:rociny/features/influencer/complete_register/data/enums/legal_document_type.dart';
import 'package:file_picker/file_picker.dart';

part 'complete_company_legal_informations_event.dart';
part 'complete_company_legal_informations_state.dart';

class CompleteCompanyLegalInformationsBloc
    extends Bloc<CompleteCompanyLegalInformationsEvent, CompleteCompanyLegalInformationsState> {
  CompleteCompanyLegalInformationsBloc({required this.crashRepository, required this.companyRepository})
      : super(CompleteLegalInitial()) {
    on<UpdateDocument>(updateDocument);
    on<CreateSetupIntent>(createSetupIntent);
  }
  final CrashRepository crashRepository;
  final CompanyRepository companyRepository;

  /// Documents status (add more)
  LegalDocumentStatus debugStatus = LegalDocumentStatus.missing;

  bool isStripeAccountCompleted = false;
  String? setupIntentSecret;
  String? ephemeralKeySecret;
  String? customerId;

  void updateDocument(UpdateDocument event, Emitter<CompleteCompanyLegalInformationsState> emit) async {
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

  void createSetupIntent(CreateSetupIntent event, Emitter<CompleteCompanyLegalInformationsState> emit) async {
    try {
      emit(CreateSetupIntentLoading());

      if (customerId == null) {
        SetupIntentDto si = await companyRepository.createSetupIntent();
        customerId = si.customerId;
        ephemeralKeySecret = si.ephemeralKeySecret;
        setupIntentSecret = si.setupIntentSecret;
      }

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
      isStripeAccountCompleted = true;
      emit(CreateSetupIntentSuccess());
    } catch (exception, stack) {
      if (exception is StripeException && exception.error.code == FailureCode.Canceled) {
        emit(CreateSetupIntentFailed(exception: AlertException(message: "stripe_setup_cancelled".translate())));

        return;
      }

      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(CreateSetupIntentFailed(exception: alertException));
    }
  }
}
