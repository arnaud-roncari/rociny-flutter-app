import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/config/environment.dart';


class FacebookButton extends StatefulWidget {
  const FacebookButton({super.key});

  @override
  State<FacebookButton> createState() => _FacebookButtonState();
}

class _FacebookButtonState extends State<FacebookButton> {
  static const platform = MethodChannel('com.example.rociny/facebook');
  String _accessToken = '';
  String _responseFromBackend = '';

  Future<void> _loginWithFacebook() async {
    try {
      final String result = await platform.invokeMethod('loginWithFacebook');
      setState(() {
        _accessToken = result;
      });

      await _sendAccessTokenToBackend(result);
    } on PlatformException catch (e) {
      setState(() {
        _accessToken = 'Erreur: ${e.message}';
      });
    }
  }

  Future<void> _sendAccessTokenToBackend(String token) async {
    final uri = Uri.parse('$kEndpoint/user/auth/me');
    final response = await http.get(
      uri.replace(queryParameters: {'access_token': token}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _responseFromBackend = jsonEncode(data);
      });
    } else {
      setState(() {
        _responseFromBackend = 'Erreur depuis le serveur : ${response.body}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(kRadius10)),
            border: Border.all(
              color: kGrey100,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(kRadius10),
            onTap: _loginWithFacebook,
            child: Center(
              child: SvgPicture.asset(
                "assets/svg/instagram.svg",
                width: 25,
                height: 25,
                color: kBlack,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text('AccessToken : $_accessToken', style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 5),
        Text('Backend : $_responseFromBackend', style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
