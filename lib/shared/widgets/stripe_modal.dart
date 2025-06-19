import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StripeModal extends StatefulWidget {
  final String url;
  const StripeModal({super.key, required this.url});

  @override
  State<StripeModal> createState() => _StripeModalState();
}

class _StripeModalState extends State<StripeModal> {
  bool isLoading = true;

  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onUrlChange: (url) {
            if (url.url!.startsWith("https://rociny.com/onboarding/complete")) {
              context.pop();
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.75,
      child: Container(
        decoration: BoxDecoration(
          color: kWhite,
        ),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: kPrimary500,
                ),
              )
            : WebViewWidget(controller: controller),
      ),
    );
  }
}
