import 'package:flutter/widgets.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPadding20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: kPadding20),

          /// TODO translate
          Text(
            "Profil",
            style: kHeadline4Bold,
          ),
          const Spacer(),
          const SizedBox(height: kPadding20),
        ],
      ),
    );
  }
}
