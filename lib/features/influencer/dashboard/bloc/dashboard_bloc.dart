import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rociny/core/repositories/crash_repository.dart';
import 'package:rociny/core/repositories/influencer_repository.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/error_handling/api_exception.dart';
import 'package:rociny/features/company/collaborations/data/model/collaboration_summary_model.dart';
import 'package:rociny/features/influencer/dashboard/data/models/influencer_statistics_model.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({required this.crashRepository, required this.influencerRepository}) : super(InitializeLoading()) {
    on<Initialize>(initialize);
  }
  final CrashRepository crashRepository;
  final InfluencerRepository influencerRepository;

  late InfluencerStatistics statistics;
  List<CollaborationSummary> collaborations = [];

  void initialize(Initialize event, Emitter<DashboardState> emit) async {
    try {
      emit(InitializeLoading());

      statistics = await influencerRepository.getStatistics();
      collaborations = await influencerRepository.getRecentCollaborations();

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
