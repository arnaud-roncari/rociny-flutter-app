import 'package:flutter/widgets.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/auth/data/models/instagram_account_model.dart';
import 'package:rociny/features/influencer/complete_profile/ui/widgets/social_network_card.dart';
import 'package:rociny/features/influencer/profile/data/models/influencer.dart';
import 'package:rociny/shared/widgets/influencer_pictures_card.dart';
import 'package:rociny/shared/widgets/instagram_statistics.dart';

class InfluencerProfile extends StatefulWidget {
  final Influencer influencer;
  final InstagramAccount? instagramAccount;
  const InfluencerProfile({super.key, required this.influencer, required this.instagramAccount});

  @override
  State<InfluencerProfile> createState() => _InfluencerProfileState();
}

class _InfluencerProfileState extends State<InfluencerProfile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// TODO afficher portfolio quand on clique sur une photo
        buildPictures(),
        buildName(),
        buildGeolocation(),
        buildStars(),
        buildDescription(),
        buildSocialNetworks(),
        buildThemes(),
        buildTargetAudience(),
        buildInstagram(),
        buildComments(),
        buildBrands(),
      ],
    );
  }

  Widget buildPictures() {
    Influencer influencer = widget.influencer;
    if (influencer.profilePicture == null && influencer.portfolio.isEmpty) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding30),
      child: InfluencerPicturesCard(
        influencer: influencer,
      ),
    );
  }

  Widget buildName() {
    Influencer influencer = widget.influencer;

    if (influencer.name == null) {
      return Container();
    }

    return Text(
      influencer.name!,
      style: kHeadline5Bold,
    );
  }

  Widget buildThemes() {
    Influencer influencer = widget.influencer;
    final List<String> themes = influencer.themes;

    if (themes.isEmpty) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "themes".translate(),
            style: kTitle1Bold,
          ),
          const SizedBox(height: kPadding20),
          SizedBox(
            height: 30,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: themes.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: kPadding10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kRadius100),
                    border: Border.all(color: kGrey100),
                  ),
                  child: Center(
                    child: Text(
                      themes[index].translate(),
                      style: kCaption,
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: kPadding10),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTargetAudience() {
    Influencer influencer = widget.influencer;
    final List<String> ta = influencer.targetAudience;

    if (ta.isEmpty) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "targets".translate(),
            style: kTitle1Bold,
          ),
          const SizedBox(height: kPadding20),
          SizedBox(
            height: 30,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: ta.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: kPadding10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kRadius100),
                    border: Border.all(color: kGrey100),
                  ),
                  child: Center(
                    child: Text(
                      ta[index],
                      style: kCaption,
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: kPadding10),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGeolocation() {
    Influencer influencer = widget.influencer;

    if (influencer.department == null) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding5),
      child: Text(
        influencer.department!,
        style: kBody.copyWith(color: kGrey300),
      ),
    );
  }

  /// TODO ajouter moyenne des notes
  Widget buildStars() {
    return Container();
  }

  Widget buildDescription() {
    Influencer influencer = widget.influencer;

    if (influencer.description == null) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding20),
      child: Text(
        influencer.description!,
        style: kBody,
      ),
    );
  }

  Widget buildSocialNetworks() {
    Influencer influencer = widget.influencer;

    if (influencer.socialNetworks.isEmpty) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: influencer.socialNetworks.map((sn) {
          return SocialNetworkCard(socialNetwork: sn);
        }).toList(),
      ),
    );
  }

  Widget buildInstagram() {
    if (widget.instagramAccount == null) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding30),
      child: InstagramStatistics(
        instagramAccount: widget.instagramAccount!,
      ),
    );
  }

  /// TODO Ajouter commentaire
  Widget buildComments() {
    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("comments".translate(), style: kTitle1Bold),
          const SizedBox(height: kPadding10),
          Text(
            "collaborate_for_comments".translate(),
            style: kBody.copyWith(color: kGrey300),
          ),
        ],
      ),
    );
  }

  /// TODO Ajouter brands
  Widget buildBrands() {
    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("brands".translate(), style: kTitle1Bold),
          const SizedBox(height: kPadding10),
          Text(
            "collab_with_brands".translate(),
            style: kBody.copyWith(color: kGrey300),
          ),
        ],
      ),
    );
  }
}
