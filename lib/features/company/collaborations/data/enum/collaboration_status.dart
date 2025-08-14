enum CollaborationStatus {
  draft,
  sentByCompany,
  refusedByInfluencer,
  canceledByCompany,
  waitingForCompanyPayment,
  inProgress,
  pendingCompanyValidation,
  done;

  /// Convert a backend string value to a CollaborationStatus enum
  static CollaborationStatus fromString(String status) {
    switch (status) {
      case 'draft':
        return CollaborationStatus.draft;
      case 'sent_by_company':
        return CollaborationStatus.sentByCompany;
      case 'refused_by_influencer':
        return CollaborationStatus.refusedByInfluencer;
      case 'canceled_by_company':
        return CollaborationStatus.canceledByCompany;
      case 'waiting_for_company_payment':
        return CollaborationStatus.waitingForCompanyPayment;
      case 'in_progress':
        return CollaborationStatus.inProgress;
      case 'pending_company_validation':
        return CollaborationStatus.pendingCompanyValidation;
      case 'done':
        return CollaborationStatus.done;
      default:
        throw ArgumentError('Unknown CollaborationStatus: $status');
    }
  }

  @override
  String toString() {
    switch (this) {
      case CollaborationStatus.draft:
        return 'draft';
      case CollaborationStatus.sentByCompany:
        return 'sent_by_company';
      case CollaborationStatus.refusedByInfluencer:
        return 'refused_by_influencer';
      case CollaborationStatus.canceledByCompany:
        return 'canceled_by_company';
      case CollaborationStatus.waitingForCompanyPayment:
        return 'waiting_for_company_payment';
      case CollaborationStatus.inProgress:
        return 'in_progress';
      case CollaborationStatus.pendingCompanyValidation:
        return 'pending_company_validation';
      case CollaborationStatus.done:
        return 'done';
    }
  }
}
