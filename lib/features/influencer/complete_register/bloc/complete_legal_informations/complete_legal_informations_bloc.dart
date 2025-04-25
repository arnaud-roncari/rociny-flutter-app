import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rociny/core/repositories/crash_repository.dart';
import 'package:rociny/core/repositories/influencer_repository.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/error_handling/api_exception.dart';
import 'package:rociny/features/influencer/complete_register/data/enums/legal_document_status.dart';
import 'package:rociny/features/influencer/complete_register/data/enums/legal_document_type.dart';
import 'package:file_picker/file_picker.dart';

part 'complete_legal_informations_event.dart';
part 'complete_legal_informations_state.dart';

class CompleteLegalInformationsBloc extends Bloc<CompleteLegalInformationsEvent, CompleteLegalInformationsState> {
  CompleteLegalInformationsBloc({required this.crashRepository, required this.influencerRepository})
      : super(CompleteLegalInitial()) {
    on<UpdateDocument>(updateDocument);
  }
  final CrashRepository crashRepository;
  final InfluencerRepository influencerRepository;

  LegalDocumentStatus debugStatus = LegalDocumentStatus.missing;

  void updateDocument(UpdateDocument event, Emitter<CompleteLegalInformationsState> emit) async {
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
}
