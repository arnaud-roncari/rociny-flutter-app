import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/influencer/profile/ui/widgets/portfolio_carousel.dart';
import 'package:rociny/shared/widgets/chip_button.dart';

class UpdatePortfolioForm extends StatelessWidget {
  final List<String> initialValue;
  final void Function() onAdded;
  final void Function(String pictureUrl) onRemoved;

  const UpdatePortfolioForm({super.key, required this.initialValue, required this.onAdded, required this.onRemoved});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Portfolio",
          style: kTitle1Bold,
        ),
        const SizedBox(height: kPadding10),
        Text(
          "edit_portfolio".translate(),
          style: kBody.copyWith(color: kGrey300),
        ),
        const SizedBox(height: kPadding20),
        ChipButton(
          label: "add".translate(),
          svgPath: "assets/svg/cloud_upload.svg",
          onTap: () async {
            onAdded();
          },
        ),
        const SizedBox(height: kPadding30),
        Expanded(
          child: PortfolioCarousel(
            pictures: initialValue,
            onPicturePressed: (pictureUrl) {
              context.push(
                "/preview_picture",
                extra: {
                  "endpoint": "$kEndpoint/influencer/portfolio/$pictureUrl",
                  "onDeleted": () => onRemoved(pictureUrl)
                } as Map,
              );
            },
          ),
        )
      ],
    );
  }
}
