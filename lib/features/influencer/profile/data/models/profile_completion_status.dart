class ProfileCompletionStatus {
  final bool hasProfilePicture;
  final bool hasName;
  final bool hasDescription;
  final bool hasDepartment;
  final bool hasSocialNetworks;
  final bool hasLegalDocuments;
  final bool hasPortofolio;
  final bool hasThemes;
  final bool hasTargetAudience;
  final bool hasStripeCompleted;
  final bool hasInstagramAccount;

  ProfileCompletionStatus({
    required this.hasProfilePicture,
    required this.hasName,
    required this.hasDescription,
    required this.hasDepartment,
    required this.hasSocialNetworks,
    required this.hasLegalDocuments,
    required this.hasPortofolio,
    required this.hasTargetAudience,
    required this.hasThemes,
    required this.hasStripeCompleted,
    required this.hasInstagramAccount,
  });

  factory ProfileCompletionStatus.fromMap(Map<String, dynamic> map) {
    return ProfileCompletionStatus(
      hasProfilePicture: map['has_profile_picture'] ?? false,
      hasName: map['has_name'] ?? false,
      hasDescription: map['has_description'] ?? false,
      hasDepartment: map['has_department'] ?? false,
      hasSocialNetworks: map['has_social_networks'] ?? false,
      hasLegalDocuments: map['has_legal_documents'] ?? false,
      hasStripeCompleted: map['has_stripe_completed'] ?? false,
      hasInstagramAccount: map['has_instagram_account'] ?? false,
      hasPortofolio: map['has_portfolio'] ?? false,
      hasTargetAudience: map['has_target_audience'] ?? false,
      hasThemes: map['has_themes'] ?? false,
    );
  }

  bool hasCompletedProfile() {
    if (!hasProfilePicture ||
        !hasName ||
        !hasDescription ||
        !hasDepartment ||
        !hasSocialNetworks ||
        !hasThemes ||
        !hasPortofolio ||
        !hasTargetAudience) {
      return false;
    }

    return true;
  }

  bool hasCompletedInstagram() {
    return hasInstagramAccount;
  }

  bool hasCompletedLegal() {
    if (!hasStripeCompleted || !hasLegalDocuments) {
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
