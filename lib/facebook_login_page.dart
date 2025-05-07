import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class FacebookLoginPage extends StatefulWidget {
  const FacebookLoginPage({Key? key}) : super(key: key);

  @override
  _FacebookLoginPageState createState() => _FacebookLoginPageState();
}

class _FacebookLoginPageState extends State<FacebookLoginPage> {
  static const platform = MethodChannel('com.example.rociny/facebook');
  String _accessToken = '';
  String _responseFromBackend = '';

  Future<void> _loginWithFacebook() async {
    try {
      final String result = await platform.invokeMethod('loginWithFacebook');
      setState(() {
        _accessToken = result;
      });

      // Après avoir reçu le token, on l'envoie au backend
      await _sendAccessTokenToBackend(_accessToken);
    } on PlatformException catch (e) {
      setState(() {
        _accessToken = 'Erreur: ${e.message}';
      });
    }
  }

  Future<void> _sendAccessTokenToBackend(String token) async {
    final uri = Uri.parse('http://192.168.0.40:3000/user/auth/me'); // 192.168.0.40 pour adresse IP du PC qui fait tourner le back
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
    return Scaffold(
      appBar: AppBar(title: const Text("Connexion Facebook")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _loginWithFacebook,
              child: const Text('Se connecter avec Facebook'),
            ),
            const SizedBox(height: 20),
            Text('AccessToken: $_accessToken'),
            const SizedBox(height: 10),
            Text('Réponse Backend: $_responseFromBackend'),
          ],
        ),
      ),
    );
  }
}
