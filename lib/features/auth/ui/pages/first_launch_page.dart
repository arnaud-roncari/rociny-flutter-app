import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/storage_keys.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/shared/widgets/button.dart';

class FirstLaunchPage extends StatefulWidget {
  const FirstLaunchPage({super.key});

  @override
  State<FirstLaunchPage> createState() => _FirstLaunchPageState();
}

class _FirstLaunchPageState extends State<FirstLaunchPage> {
  PageController pageController = PageController();
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    double topSafeZone = MediaQuery.of(context).padding.top;
    double bottomSafeZone = MediaQuery.of(context).padding.bottom;

    final List<String> titles = [
      "advanced_search".translate(),
      "synchronized_statistics".translate(),
      "secure_collaborations".translate(),
      "instant_payments".translate(),
    ];
    final List<String> descriptions = [
      "find_influencer_with_filters".translate(),
      "instagram_data_updated_daily".translate(),
      "contract_automatically_drafted".translate(),
      "payments_within_48_hours".translate(),
    ];

    return Scaffold(
      backgroundColor: kPrimary700,
      body: Column(
        children: [
          SizedBox(height: topSafeZone),
          Expanded(
            child: Container(
              child: PageView(
                controller: pageController,
                onPageChanged: (value) {
                  setState(() {
                    pageIndex = value;
                  });
                },
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset("assets/images/first_launch/1.png"),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset("assets/images/first_launch/2.png"),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset("assets/images/first_launch/3.png"),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset("assets/images/first_launch/4.png"),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: kWhite,
            constraints: BoxConstraints(maxHeight: 300, maxWidth: double.infinity),
            child: Padding(
              padding: const EdgeInsets.all(kPadding20),
              child: Column(
                children: [
                  buildIndicator(),
                  Spacer(),
                  Text(
                    titles[pageIndex],
                    style: kHeadline4Bold,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: kPadding20),
                  Text(
                    descriptions[pageIndex],
                    style: kTitle2.copyWith(
                      color: kGrey300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Spacer(),
                  Button(
                      title: "next".translate(),
                      onPressed: () async {
                        if (pageIndex == 3) {
                          /// Thise logic should be stored in a BLoC.
                          /// But since it's only those 2 lines, we kept since simple by doing it here.
                          FlutterSecureStorage storage = const FlutterSecureStorage();
                          await storage.write(key: kKeyFirstLaunch, value: "FALSE");
                          context.go('/login');
                        } else {
                          pageIndex++;
                          pageController.jumpToPage(pageIndex);
                        }
                      })
                ],
              ),
            ),
          ),
          Container(color: kWhite, height: bottomSafeZone),
        ],
      ),
    );
  }

  Widget buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPadding5),
          child: Container(
            width: i == pageIndex ? 50 : 10,
            height: 10,
            decoration: BoxDecoration(
              color: i == pageIndex ? kPrimary700 : kGrey100,
              borderRadius: BorderRadius.circular(kRadius100),
            ),
          ),
        );
      }),
    );
  }
}
