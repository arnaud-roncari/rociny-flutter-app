class SetupIntentDto {
  final String setupIntentSecret;
  final String ephemeralKeySecret;
  final String customerId;

  SetupIntentDto({
    required this.setupIntentSecret,
    required this.ephemeralKeySecret,
    required this.customerId,
  });

  factory SetupIntentDto.fromJson(Map<String, dynamic> json) {
    return SetupIntentDto(
      setupIntentSecret: json['setup_intent_secret'] as String,
      ephemeralKeySecret: json['ephemeral_key_secret'] as String,
      customerId: json['customer_id'] as String,
    );
  }
}
