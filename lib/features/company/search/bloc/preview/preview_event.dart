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

/// ---

class CreateProductPlacement extends PreviewEvent {
  final ProductPlacement productPlacement;

  CreateProductPlacement({required this.productPlacement});
}

class RemoveProductPlacement extends PreviewEvent {
  final ProductPlacement productPlacement;

  RemoveProductPlacement({required this.productPlacement});
}

/// ---

class PickFiles extends PreviewEvent {}

class RemoveFile extends PreviewEvent {
  final File file;

  RemoveFile({required this.file});
}

/// ---

class CreateCollaboration extends PreviewEvent {
  final bool isDraft;

  CreateCollaboration({required this.isDraft});
}
