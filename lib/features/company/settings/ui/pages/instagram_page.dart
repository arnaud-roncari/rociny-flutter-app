import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

class InstagramPage extends StatefulWidget {
  const InstagramPage({super.key});

  @override
  State<InstagramPage> createState() => _InstagramPageState();
}

class _InstagramPageState extends State<InstagramPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(kPadding20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgButton(
                  path: "assets/svg/left_arrow.svg",
                  color: kBlack,
                  onPressed: () {
                    context.pop();
                  },
                ),
                const Spacer(),
                Text(
                  "Instagram",
                  style: kTitle1Bold,
                ),
                const Spacer(),
                const SizedBox(width: kPadding20),
              ],
            ),
            const SizedBox(height: kPadding30),
            const Placeholder(),
          ],
        ),
      )),
    );
  }
}
