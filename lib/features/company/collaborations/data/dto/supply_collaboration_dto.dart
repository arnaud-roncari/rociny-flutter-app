class SupplyCollaborationDto {
  final String clientSecret;
  final String ephemeralKey;

  SupplyCollaborationDto({
    required this.clientSecret,
    required this.ephemeralKey,
  });

  factory SupplyCollaborationDto.fromJson(Map<String, dynamic> json) {
    return SupplyCollaborationDto(
      clientSecret: json["client_secret"],
      ephemeralKey: json["ephemeral_key"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "client_secret": clientSecret,
      "ephemeral_key": ephemeralKey,
    };
  }
}
