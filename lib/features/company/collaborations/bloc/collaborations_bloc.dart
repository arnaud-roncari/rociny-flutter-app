import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rociny/core/repositories/company_repository.dart';
import 'package:rociny/core/repositories/crash_repository.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/error_handling/api_exception.dart';
import 'package:rociny/features/company/collaborations/data/model/collaboration_summary_model.dart';

part 'collaborations_event.dart';
part 'collaborations_state.dart';

/// TODO pouvoir refresh meme quand c'est vide
class CollaborationsBloc extends Bloc<CollaborationsEvent, CollaborationsState> {
  CollaborationsBloc({required this.crashRepository, required this.companyRepository}) : super(InitializeLoading()) {
    on<Initialize>(initialize);
  }
  final CrashRepository crashRepository;
  final CompanyRepository companyRepository;

  late List<CollaborationSummary> summaries;

  void initialize(Initialize event, Emitter<CollaborationsState> emit) async {
    try {
      emit(InitializeLoading());
      summaries = await companyRepository.getCollaborationSummaries();

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
