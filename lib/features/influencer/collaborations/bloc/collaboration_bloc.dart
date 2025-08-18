import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rociny/core/repositories/crash_repository.dart';
import 'package:rociny/core/repositories/influencer_repository.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/error_handling/api_exception.dart';
import 'package:rociny/features/auth/data/models/instagram_account_model.dart';
import 'package:rociny/features/company/collaborations/data/enum/collaboration_status.dart';
import 'package:rociny/features/company/profile/data/models/company.dart';
import 'package:rociny/features/company/search/data/models/collaboration_model.dart';
import 'package:rociny/features/company/search/data/models/review_model.dart';
import 'package:rociny/features/influencer/profile/data/models/influencer.dart';

part 'collaboration_event.dart';
part 'collaboration_state.dart';

class CollaborationBloc extends Bloc<CollaborationEvent, CollaborationState> {
  CollaborationBloc({required this.crashRepository, required this.influencerRepository}) : super(InitializeLoading()) {
    on<Initialize>(initialize);
    on<CreateReview>(createReview);
    on<AcceptCollaboration>(acceptCollaboration);
    on<RefuseCollaboration>(refuseCollaboration);
    on<EndCollaboration>(endCollaboration);
  }
  final CrashRepository crashRepository;
  final InfluencerRepository influencerRepository;

  late Influencer influencer;
  late Company company;
  late Collaboration collaboration;
  late InstagramAccount instagramAccount;
  bool hasReviewed = false;
  Review? review;

  void initialize(Initialize event, Emitter<CollaborationState> emit) async {
    try {
      emit(InitializeLoading());

      final results = await Future.wait([
        influencerRepository.getInfluencer(),
        influencerRepository.getCollaboration(event.collaborationId),
        influencerRepository.getCompany(event.userId),
      ]);
      influencer = results[0] as Influencer;
      collaboration = results[1] as Collaboration;
      company = results[2] as Company;

      if (CollaborationStatus.fromString(collaboration.status) == CollaborationStatus.done) {
        final reviewResults = await Future.wait([
          influencerRepository.getReview(
            collaboration.id,
            influencer.userId,
            company.userId,
          ),
          influencerRepository.getReview(
            collaboration.id,
            company.userId,
            influencer.userId,
          ),
        ]);
        hasReviewed = reviewResults[0] != null;
        review = reviewResults[1];
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

  void acceptCollaboration(AcceptCollaboration event, Emitter<CollaborationState> emit) async {
    try {
      emit(AcceptCollaborationLoading());
      await influencerRepository.acceptCollaboration(collaboration.id);
      collaboration = await influencerRepository.getCollaboration(collaboration.id);
      emit(AcceptCollaborationSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(AcceptCollaborationFailed(exception: alertException));
    }
  }

  void refuseCollaboration(RefuseCollaboration event, Emitter<CollaborationState> emit) async {
    try {
      emit(RefuseCollaborationLoading());
      await influencerRepository.refuseCollaboration(collaboration.id);
      collaboration = await influencerRepository.getCollaboration(collaboration.id);
      emit(RefuseCollaborationSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(RefuseCollaborationFailed(exception: alertException));
    }
  }

  void endCollaboration(EndCollaboration event, Emitter<CollaborationState> emit) async {
    try {
      emit(EndCollaborationLoading());
      await influencerRepository.endCollaboration(collaboration.id);
      collaboration = await influencerRepository.getCollaboration(collaboration.id);
      emit(EndCollaborationSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(EndCollaborationFailed(exception: alertException));
    }
  }

  void createReview(CreateReview event, Emitter<CollaborationState> emit) async {
    try {
      emit(CreateReviewLoading());
      await influencerRepository.createReview(
        collaboration.id,
        company.userId,
        event.stars,
        event.description,
      );
      emit(CreateReviewSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(CreateReviewFailed(exception: alertException));
    }
  }
}
