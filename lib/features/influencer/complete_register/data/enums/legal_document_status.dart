import 'package:rociny/core/utils/extensions/translate.dart';

enum LegalDocumentStatus {
  missing,
  pending,
  validated,
  refused,
}

String getDisplayedName(LegalDocumentStatus status) {
  switch (status) {
    case LegalDocumentStatus.missing:
      return 'to_provide'.translate();
    case LegalDocumentStatus.pending:
      return 'verification_in_progress'.translate();
    case LegalDocumentStatus.validated:
      return 'validated'.translate();
    case LegalDocumentStatus.refused:
      return 'rejected'.translate();
  }
}
