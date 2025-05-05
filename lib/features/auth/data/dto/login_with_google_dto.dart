class LoginWithGoogleDto {
  final String status;
  final String? jwt;
  final String? providerUserId;
  LoginWithGoogleDto({required this.status, this.jwt, this.providerUserId});

  factory LoginWithGoogleDto.fromJson(Map<String, dynamic> json) {
    return LoginWithGoogleDto(
      status: json['status'] as String,
      jwt: json['access_token'] as String?,
      providerUserId: json['provider_user_id'] as String?,
    );
  }
}
