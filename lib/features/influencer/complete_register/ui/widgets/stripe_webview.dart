import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/shared/widgets/svg_button.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StripeWebview extends StatefulWidget {
  final String url;
  const StripeWebview({super.key, required this.url});

  @override
  State<StripeWebview> createState() => _StripeWebviewState();
}

class _StripeWebviewState extends State<StripeWebview> {
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
              context.pop(true);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: kPrimary500,
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: kPadding20, top: kPadding20, bottom: kPadding20),
                    child: SvgButton(
                      path: "assets/svg/left_arrow.svg",
                      color: kBlack,
                      onPressed: () {
                        context.pop();
                      },
                    ),
                  ),
                  Expanded(child: WebViewWidget(controller: controller)),
                ],
              ),
      ),
    );
  }
}
