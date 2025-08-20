part of 'dashboard_bloc.dart';

sealed class DashboardState {}

/// ---

class InitializeLoading extends DashboardState {}

class InitializeSuccess extends DashboardState {}

class InitializeFailed extends DashboardState {
  final AlertException exception;

  InitializeFailed({required this.exception});
}
