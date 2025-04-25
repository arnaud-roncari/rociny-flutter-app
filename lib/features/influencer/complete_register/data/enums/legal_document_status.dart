enum LegalDocumentStatus {
  missing,
  pending,
  validated,
  refused,
}

/// TODO translate
String getDisplayedName(LegalDocumentStatus status) {
  switch (status) {
    case LegalDocumentStatus.missing:
      return 'À fournir';
    case LegalDocumentStatus.pending:
      return 'Vérification en cours';
    case LegalDocumentStatus.validated:
      return 'Validé';
    case LegalDocumentStatus.refused:
      return 'Refusé';
  }
}
