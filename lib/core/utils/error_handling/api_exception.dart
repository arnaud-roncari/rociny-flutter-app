class ApiException {
  final int statusCode;
  final String? id;
  final String? message;

  ApiException({required this.statusCode, this.id, this.message});

  /// Note: If the JWT session has been stopped, the UI should redirect the user to the login page.
  /// This scenario might occur if the user updates their password or email, as this would invalidate the previous JWT, causing this behavior.
  static ApiException fromJson(int statusCode, Map<String, dynamic> json) {
    return ApiException(
      statusCode: statusCode,
      id: json["id"],
      message: json["message"],
    );
  }
}
