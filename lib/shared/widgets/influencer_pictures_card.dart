import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/features/influencer/profile/data/models/influencer.dart';

class InfluencerPicturesCard extends StatefulWidget {
  final Influencer influencer;
  const InfluencerPicturesCard({super.key, required this.influencer});

  @override
  State<InfluencerPicturesCard> createState() => _InfluencerPicturesCardState();
}

class _InfluencerPicturesCardState extends State<InfluencerPicturesCard> {
  late List<String> pictureUrls;
  late PageController _pageController;
  int index = 0;

  @override
  void initState() {
    super.initState();
    final hasProfilePicture = widget.influencer.profilePicture != null;
    pictureUrls = [
      if (hasProfilePicture) widget.influencer.profilePicture!,
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

        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kRadius10),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(kRadius10),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: pictureUrls.length,
                  onPageChanged: (newIndex) {
                    setState(() => index = newIndex);
                  },
                  itemBuilder: (context, i) {
                    final pictureId = pictureUrls[i];
                    final isProfile = i == 0 && widget.influencer.profilePicture != null;

                    final imageUrl = isProfile
                        ? "$kEndpoint/influencer/profile-pictures/${widget.influencer.profilePicture}"
                        : "$kEndpoint/influencer/portfolio/$pictureId";

                    return InkWell(
                      onTap: () {
                        context.push("/portfolio", extra: widget.influencer);
                      },
                      child: Image(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                          imageUrl,
                          headers: {"Authorization": "Bearer $kJwt"},
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(kPadding20),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: 20,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kRadius5),
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: Center(
                      child: Text(
                        "${index + 1} / ${pictureUrls.length}",
                        style: kCaption.copyWith(color: kWhite),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
