import 'dart:convert';
import 'package:http/http.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/utils/error_handling/api_exception.dart';

class FacebookRepository {
  Future<String> getClientId() async {
    var response = await get(
      Uri.parse('$kEndpoint/facebook/client-id'),
      headers: {
        'Authorization': 'Bearer $kJwt',
      },
    );

    if (response.statusCode >= 400) {
      Map<String, dynamic> body = jsonDecode(response.body);
      throw ApiException.fromJson(response.statusCode, body);
    }
    Map<String, dynamic> body = jsonDecode(response.body);
    return body["client_id"];
  }
}
