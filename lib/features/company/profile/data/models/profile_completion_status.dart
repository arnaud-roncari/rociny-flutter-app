class ProfileCompletionStatus {
  final bool hasProfilePicture;
  final bool hasName;
  final bool hasDescription;
  final bool hasDepartment;
  final bool hasSocialNetworks;
  final bool hasLegalDocuments;
  final bool hasStripePaymentMethod;
  final bool hasInstagramAccount;
  final bool hasBillingAddress;
  final bool hasTradeName;

  ProfileCompletionStatus({
    required this.hasProfilePicture,
    required this.hasName,
    required this.hasDescription,
    required this.hasDepartment,
    required this.hasSocialNetworks,
    required this.hasLegalDocuments,
    required this.hasStripePaymentMethod,
    required this.hasInstagramAccount,
    required this.hasBillingAddress,
    required this.hasTradeName,
  });

  factory ProfileCompletionStatus.fromMap(Map<String, dynamic> map) {
    return ProfileCompletionStatus(
      hasProfilePicture: map['has_profile_picture'] ?? false,
      hasName: map['has_name'] ?? false,
      hasDescription: map['has_description'] ?? false,
      hasDepartment: map['has_department'] ?? false,
      hasSocialNetworks: map['has_social_networks'] ?? false,
      hasLegalDocuments: map['has_legal_documents'] ?? false,
      hasStripePaymentMethod: map['has_stripe_payment_method'] ?? false,
      hasInstagramAccount: map['has_instagram_account'] ?? false,
      hasBillingAddress: map['has_billing_address'] ?? false,
      hasTradeName: map['has_trade_name'] ?? false,
    );
  }

  bool hasCompletedProfile() {
    if (!hasProfilePicture || !hasName || !hasDescription || !hasDepartment || !hasSocialNetworks) {
      return false;
    }

    return true;
  }

  bool hasCompletedInstagram() {
    return hasInstagramAccount;
  }

  bool hasCompletedLegal() {
    if (!hasStripePaymentMethod || !hasLegalDocuments || !hasBillingAddress || !hasTradeName) {
      return false;
    }

    return true;
  }

  bool isCompleted() {
    if (!hasCompletedInstagram() || !hasCompletedLegal() || !hasCompletedProfile()) {
      return false;
    }
    return true;
  }
}
