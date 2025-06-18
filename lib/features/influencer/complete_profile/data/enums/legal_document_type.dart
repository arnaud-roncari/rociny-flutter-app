enum LegalDocumentType {
  debug,
}

String getDisplayedName(LegalDocumentType type) {
  switch (type) {
    case LegalDocumentType.debug:
      return 'Nom du document';
  }
}
