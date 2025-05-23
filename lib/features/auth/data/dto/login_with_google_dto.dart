class LoginWithProviderDto {
  final String status;
  final String? jwt;
  final String? providerUserId;
  LoginWithProviderDto({required this.status, this.jwt, this.providerUserId});

  factory LoginWithProviderDto.fromJson(Map<String, dynamic> json) {
    return LoginWithProviderDto(
      status: json['status'] as String,
      jwt: json['access_token'] as String?,
      providerUserId: json['provider_user_id'] as String?,
    );
  }
}
