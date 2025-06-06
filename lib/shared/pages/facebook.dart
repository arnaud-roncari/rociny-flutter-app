// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/repositories/facebook_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class FacebookPage extends StatefulWidget {
  const FacebookPage({super.key});

  @override
  State<FacebookPage> createState() => _FacebookPageState();
}

class _FacebookPageState extends State<FacebookPage> with WidgetsBindingObserver {
  late String clientId;
  final String redirectUri = '$kEndpoint/user/auth/login-with-facebook';
  final String responseType = 'code';
  final String scope =
      "email,public_profile,pages_show_list,pages_read_engagement,instagram_basic,instagram_manage_insights,business_management";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      /// Fetch facebook client id
      clientId = await FacebookRepository().getClientId();

      /// Initiate oauth
      final authUrl = Uri.parse(
        'https://www.facebook.com/v19.0/dialog/oauth'
        '?client_id=$clientId'
        '&redirect_uri=$redirectUri'
        '&response_type=$responseType'
        '&scope=$scope'
        '&state=$kJwt',
      );
      if (await canLaunchUrl(authUrl)) {
        await launchUrl(authUrl, mode: LaunchMode.externalApplication);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kPadding20),
          child: Center(
            child: CircularProgressIndicator(
              color: kPrimary500,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.pop();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
