import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/features/influencer/profile/data/models/influencer.dart';
import 'package:rociny/features/influencer/profile/ui/widgets/portfolio_carousel.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

class PortfolioPage extends StatelessWidget {
  final Influencer influencer;
  const PortfolioPage({super.key, required this.influencer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kPadding20),
          child: Column(
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
                ],
              ),
              const SizedBox(height: kPadding20),
              Expanded(
                child: PortfolioCarousel(
                  pictures: influencer.portfolio,
                  onPicturePressed: (pictureUrl) {
                    context.push(
                      "/preview_picture",
                      extra: {
                        "endpoint": "$kEndpoint/influencer/portfolio/$pictureUrl",
                      } as Map,
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
