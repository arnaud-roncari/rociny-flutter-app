import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/features/company/search/data/models/influencer_summary_model.dart';
import 'package:rociny/features/company/search/ui/widgets/image_dots_indicator.dart';

class InfluencerSummaryCard extends StatefulWidget {
  final void Function(InfluencerSummary influencer) onPressed;
  final InfluencerSummary influencer;
  const InfluencerSummaryCard({super.key, required this.influencer, required this.onPressed});

  @override
  State<InfluencerSummaryCard> createState() => _InfluencerSummaryCardState();
}

class _InfluencerSummaryCardState extends State<InfluencerSummaryCard> {
  late List<String> pictureUrls;
  late PageController _pageController;
  int index = 0;

  @override
  void initState() {
    super.initState();
    pictureUrls = [
      widget.influencer.profilePicture,
      widget.influencer.profilePicture,
      widget.influencer.profilePicture,
      widget.influencer.profilePicture,
      widget.influencer.profilePicture,
      widget.influencer.profilePicture,
      widget.influencer.profilePicture,
      ...widget.influencer.portfolio,
    ];
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double size = constraints.maxWidth;

        return ClipRRect(
          borderRadius: BorderRadius.circular(kRadius10),
          child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: pictureUrls.length,
                  onPageChanged: (newIndex) {
                    setState(() => index = newIndex);
                  },
                  itemBuilder: (context, i) {
                    final pictureId = pictureUrls[i];
                    final isProfile = i == 0;

                    final imageUrl = isProfile
                        ? "$kEndpoint/influencer/get-profile-picture/${widget.influencer.userId}?uuid=${widget.influencer.profilePicture}"
                        : "$kEndpoint/influencer/get-portfolio/$pictureId/${widget.influencer.userId}";

                    return InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        widget.onPressed(widget.influencer);
                      },
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                              imageUrl,
                              headers: {"Authorization": "Bearer $kJwt"},
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Color.fromRGBO(0, 0, 0, 0.25),
                                ],
                                stops: [0, 1],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // Dots indicator for images, max 5, aligned center bottom
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: kPadding15),
                    child: ImageDotsIndicator(currentIndex: index, total: pictureUrls.length),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: kPadding30, left: kPadding20, right: kPadding20),
                    child: Column(
                      children: [
                        const Spacer(),
                        Row(
                          children: [
                            Text(
                              "Yvick Letexier",
                              style: kBodyBold.copyWith(color: kWhite),
                            ),
                            const Spacer(),
                            Text(
                              "0 Collaborations",
                              style: kCaption.copyWith(color: kWhite),
                            ),
                          ],
                        ),
                        const SizedBox(height: kPadding10),
                        Row(
                          children: [
                            Text(
                              "${widget.influencer.getFollowers()} Followers",
                              style: kCaption.copyWith(color: kWhite),
                            ),
                            const Spacer(),
                            Text(
                              "0",
                              style: kCaption.copyWith(color: kWhite),
                            ),
                            const SizedBox(width: kPadding5),
                            SvgPicture.asset(
                              "assets/svg/star.svg",
                              width: 15,
                              height: 15,
                              colorFilter: ColorFilter.mode(kWhite, BlendMode.srcIn),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
