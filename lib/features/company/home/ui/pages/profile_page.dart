import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPadding20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: kPadding20),
          Row(
            children: [
              Text(
                "profile".translate(),
                style: kHeadline4Bold,
              ),
              const Spacer(),
              SizedBox(
                child: SvgButton(
                    path: "assets/svg/settings.svg",
                    color: kBlack,
                    onPressed: () {
                      context.push("/company/settings");
                    }),
              )
            ],
          ),
          const Spacer(),
          const SizedBox(height: kPadding20),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
