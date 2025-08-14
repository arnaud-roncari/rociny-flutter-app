import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:rociny/core/repositories/company_repository.dart';
import 'package:rociny/core/repositories/crash_repository.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/error_handling/api_exception.dart';
import 'package:rociny/features/auth/data/models/instagram_account_model.dart';
import 'package:rociny/features/auth/data/models/review_model.dart';
import 'package:rociny/features/company/collaborations/data/enum/collaboration_status.dart';
import 'package:rociny/features/company/profile/data/models/company.dart';
import 'package:rociny/features/company/search/data/models/collaboration_model.dart';
import 'package:rociny/features/influencer/profile/data/models/influencer.dart';

part 'collaboration_event.dart';
part 'collaboration_state.dart';

/// TODO faire payer els frais stripe  àl'entreprise 1,5% + 0,25 (voir comment mieux gérer cet aspect pour la rentabiltié,a vec chatgpt)
/// TODO fix le fait de devoir remettre sa cb a chaque fois
/// 4242 4242 4242 4242
/// 4000 0000 0000 0077

class CollaborationBloc extends Bloc<CollaborationEvent, CollaborationState> {
  CollaborationBloc({required this.crashRepository, required this.companyRepository}) : super(InitializeLoading()) {
    on<Initialize>(initialize);
    on<CancelCollaboration>(cancelCollaboration);
    on<SendDraftCollaboration>(sendDraftCollaboration);
    on<SupplyCollaboration>(supplyCollaboration);
    on<ValidateCollaboration>(validateCollaboration);
    on<CreateReview>(createReview);
  }
  final CrashRepository crashRepository;
  final CompanyRepository companyRepository;

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
        companyRepository.getInfluencer(event.userId),
        companyRepository.getCollaboration(event.collaborationId),
        companyRepository.getInfluencerInstagramAccount(event.userId),
        companyRepository.getCompany(),
      ]);
      influencer = results[0] as Influencer;
      collaboration = results[1] as Collaboration;
      instagramAccount = results[2] as InstagramAccount;
      company = results[3] as Company;

      if (CollaborationStatus.fromString(collaboration.status) == CollaborationStatus.done) {
        final reviewResults = await Future.wait([
          companyRepository.getReview(
            collaboration.id,
            company.userId,
            influencer.userId,
          ),
          companyRepository.getReview(
            collaboration.id,
            influencer.userId,
            company.userId,
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

  void cancelCollaboration(CancelCollaboration event, Emitter<CollaborationState> emit) async {
    try {
      emit(CancelCollaborationLoading());
      await companyRepository.cancelCollaboration(collaboration.id);
      collaboration = await companyRepository.getCollaboration(collaboration.id);
      emit(CancelCollaborationSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(CancelCollaborationFailed(exception: alertException));
    }
  }

  void sendDraftCollaboration(SendDraftCollaboration event, Emitter<CollaborationState> emit) async {
    try {
      emit(SendDraftCollaborationLoading());
      await companyRepository.sendDraftCollaboration(collaboration.id);
      collaboration = await companyRepository.getCollaboration(collaboration.id);
      emit(SendDraftCollaborationSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(SendDraftCollaborationFailed(exception: alertException));
    }
  }

  void supplyCollaboration(SupplyCollaboration event, Emitter<CollaborationState> emit) async {
    try {
      emit(SupplyCollaborationLoading());

      String cs = await companyRepository.supplyCollaboration(collaboration.id);
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: cs,
          merchantDisplayName: 'Rociny',
          allowsDelayedPaymentMethods: true,
        ),
      );
      await Stripe.instance.presentPaymentSheet();

      await Future.delayed(const Duration(seconds: 2));
      collaboration = await companyRepository.getCollaboration(collaboration.id);
      emit(SupplyCollaborationSuccess());
    } catch (exception, stack) {
      /// TODO catch stripe erreur si fermé
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(SupplyCollaborationFailed(exception: alertException));
    }
  }

  void validateCollaboration(ValidateCollaboration event, Emitter<CollaborationState> emit) async {
    try {
      emit(ValidateCollaborationLoading());
      await companyRepository.validateCollaboration(collaboration.id);
      collaboration = await companyRepository.getCollaboration(collaboration.id);
      emit(ValidateCollaborationSuccess());
    } catch (exception, stack) {
      if (exception is! ApiException) {
        crashRepository.registerCrash(exception, stack);
      }

      /// Format exception to be displayed.
      AlertException alertException = AlertException.fromException(exception);
      emit(ValidateCollaborationFailed(exception: alertException));
    }
  }

  void createReview(CreateReview event, Emitter<CollaborationState> emit) async {
    try {
      emit(CreateReviewLoading());
      await companyRepository.createReview(
        collaboration.id,
        influencer.userId,
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

  /// TODO fixer (un fichier est nécéssaire) lors de la creationd 'une collab
}
