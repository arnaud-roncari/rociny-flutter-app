import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/company/complete_profile/bloc/complete_profile/complete_profile_bloc.dart';
import 'package:rociny/shared/widgets/button.dart';

class ProfileIllustrationPage extends StatefulWidget {
  const ProfileIllustrationPage({super.key});

  @override
  State<ProfileIllustrationPage> createState() => ProfileIllustrationPageState();
}

class ProfileIllustrationPageState extends State<ProfileIllustrationPage> {
  int pageIndex = 0;

  @override
  void initState() {
    context.read<CompleteProfileBloc>().add(GetProfile());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double topSafeZone = MediaQuery.of(context).padding.top;
    double bottomSafeZone = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: kPrimary700,
      body: Column(
        children: [
          SizedBox(height: topSafeZone),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset("assets/images/complete_profile/3.png"),
            ),
          ),
          Container(
            color: kWhite,
            constraints: const BoxConstraints(maxHeight: 300, maxWidth: double.infinity),
            child: Padding(
              padding: const EdgeInsets.all(kPadding20),
              child: Column(
                children: [
                  buildIndicator(),
                  const Spacer(),
                  Text(
                    "my_profile".translate(),
                    style: kHeadline4Bold,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: kPadding20),
                  Text(
                    "company_profile_tip".translate(),
                    style: kTitle2.copyWith(
                      color: kGrey300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  Button(
                    title: "complete".translate(),
                    backgroundColor: kPrimary700,
                    onPressed: () async {
                      context.push("/company/complete_profile/profile");
                    },
                  )
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
      children: List.generate(2, (i) {
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
