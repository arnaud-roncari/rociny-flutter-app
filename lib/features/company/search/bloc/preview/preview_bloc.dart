import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rociny/core/repositories/company_repository.dart';
import 'package:rociny/core/repositories/crash_repository.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/error_handling/api_exception.dart';
import 'package:rociny/features/auth/data/models/instagram_account.dart';
import 'package:rociny/features/company/profile/data/models/profile_completion_status.dart';
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
  }
  final CrashRepository crashRepository;
  final CompanyRepository companyRepository;

  /// Influencer
  late i.ProfileCompletionStatus influencerProfileCompletion;
  late Influencer influencer;
  InstagramAccount? instagramAccount;

  /// Company
  late ProfileCompletionStatus companyProfileCompletion;

  void initialize(Initialize event, Emitter<PreviewState> emit) async {
    try {
      emit(InitializeLoading());

      influencerProfileCompletion = await companyRepository.getInfluencerCompletionStatus(event.userId);
      influencer = await companyRepository.getInfluencer(event.userId);
      if (influencerProfileCompletion.hasInstagramAccount) {
        instagramAccount = await companyRepository.getInfluencerInstagramAccount(event.userId);
      }

      companyProfileCompletion = await companyRepository.getProfileCompletionStatus();

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
}
