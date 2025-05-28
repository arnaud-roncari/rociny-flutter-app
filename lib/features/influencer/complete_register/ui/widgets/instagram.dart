import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/influencer/complete_register/bloc/complete_influencer_profile_informations/complete_influencer_profile_informations_bloc.dart';
import 'package:rociny/shared/widgets/button.dart';
import 'package:http/http.dart' as http;
import 'package:rociny/core/config/environment.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Instagram extends StatefulWidget {
  const Instagram({super.key});

  @override
  State<Instagram> createState() => _InstagramState();
}

class _InstagramState extends State<Instagram> {
static const platform = MethodChannel('com.example.rociny/facebook');
  String _accessToken = '';
  String _responseFromBackend = '';

  Future<void> linkWithFacebook() async {
    try {
      final String result = await platform.invokeMethod('loginWithFacebook');
      setState(() {
        _accessToken = result;
      });

      await _sendAccessTokenToBackend(result);
    } on PlatformException catch (e) {
      setState(() {
        _accessToken = 'Erreur: ${e.message} et : ${e}';
      });
    }
  }

  Future<void> _sendAccessTokenToBackend(String token) async {

    final uri = Uri.parse('$kEndpoint/user/auth/link');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json',
      'Authorization': 'Bearer $kJwt'},
      body: json.encode({'userAccessToken': token}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      setState(() {
        _responseFromBackend = jsonEncode(data);
      });
    } else {
      setState(() {
        _responseFromBackend = 'Erreur depuis le serveur : ${response.body} et code = ${response.statusCode}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompleteInfluencerProfileInformationsBloc, CompleteInfluencerProfileInformationsState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Instagram",
              style: kTitle1Bold,
            ),
            const SizedBox(height: kPadding10),
            Text('AccessToken : $_accessToken', style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 5),
            Text('Backend : $_responseFromBackend', style: const TextStyle(fontSize: 12)),
            Text(
              "instagram_connect".translate(),
              style: kBody.copyWith(color: kGrey300),
            ),
            const Spacer(),
            Button(
              backgroundColor: kBlack,
              title: "connect".translate(),
              onPressed: linkWithFacebook,
            ),
            const SizedBox(height: kPadding10),
          ],
        );
      },
    );
  }
}
