import 'package:flutter/widgets.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/shared/widgets/chip_button.dart';

class UpdateProfilePictureForm extends StatefulWidget {
  final String? initialValue;
  final void Function() onUpdated;
  const UpdateProfilePictureForm({
    super.key,
    required this.onUpdated,
    required this.initialValue,
  });

  @override
  State<UpdateProfilePictureForm> createState() => _UpdateProfilePictureFormState();
}

class _UpdateProfilePictureFormState extends State<UpdateProfilePictureForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "profile_picture".translate(),
          style: kTitle1Bold,
        ),
        const SizedBox(height: kPadding10),
        Text(
          "publish_your_profile_picture".translate(),
          style: kBody.copyWith(color: kGrey300),
        ),
        const SizedBox(height: kPadding20),
        ChipButton(
          label: "profile_picture".translate(),
          svgPath: "assets/svg/upload.svg",
          onTap: () {
            widget.onUpdated();
          },
        ),
        const SizedBox(height: kPadding30),
        if (widget.initialValue != null)
          LayoutBuilder(builder: (context, constraints) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kRadius10),
              ),
              width: constraints.maxWidth,
              height: constraints.maxWidth,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(kRadius10),
                child: Image(
                  image: NetworkImage(
                    "$kEndpoint/influencer/get-profile-picture?dummy=${DateTime.now().millisecondsSinceEpoch}",
                    headers: {
                      'Authorization': 'Bearer $kJwt',
                    },
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            );
          }),
        const Spacer(),
      ],
    );
  }
}
