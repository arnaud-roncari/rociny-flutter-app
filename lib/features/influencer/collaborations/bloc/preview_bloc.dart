import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rociny/core/repositories/crash_repository.dart';
import 'package:rociny/core/repositories/influencer_repository.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/error_handling/api_exception.dart';
import 'package:rociny/features/auth/data/models/instagram_account_model.dart';
import 'package:rociny/features/company/profile/data/models/company.dart';
import 'package:rociny/features/company/profile/data/models/profile_completion_status.dart';
import 'package:rociny/features/company/search/data/enums/product_placement_type.dart';
import 'package:rociny/features/company/search/data/models/product_placement_model.dart';

part 'preview_event.dart';
part 'preview_state.dart';

class PreviewBloc extends Bloc<PreviewEvent, PreviewState> {
  PreviewBloc({
    required this.crashRepository,
    required this.influencerRepository,
  }) : super(InitializeLoading()) {
    on<Initialize>(initialize);
  }
  final CrashRepository crashRepository;
  final InfluencerRepository influencerRepository;

  late ProfileCompletionStatus completion;
  late Company company;
  InstagramAccount? instagramAccount;

  void initialize(Initialize event, Emitter<PreviewState> emit) async {
    try {
      emit(InitializeLoading());

      final results = await Future.wait([
        influencerRepository.getCompanyCompletionStatus(event.userId),
        influencerRepository.getCompany(event.userId),
      ]);

      completion = results[0] as ProfileCompletionStatus;
      company = results[1] as Company;

      if (completion.hasInstagramAccount) {
        instagramAccount = await influencerRepository.getCompanyInstagramAccount(event.userId);
      }

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
}
