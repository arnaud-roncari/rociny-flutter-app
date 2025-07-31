part of 'preview_bloc.dart';

sealed class PreviewEvent {}

class Initialize extends PreviewEvent {
  final int userId;

  Initialize({required this.userId});
}

/// ---

class UpdateStep extends PreviewEvent {
  final int index;

  UpdateStep({required this.index});
}
