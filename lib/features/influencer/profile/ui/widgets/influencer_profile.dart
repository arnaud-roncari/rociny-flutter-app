import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/auth/data/models/instagram_account_model.dart';
import 'package:rociny/features/company/profile/data/models/review_summary.dart';
import 'package:rociny/features/influencer/complete_profile/ui/widgets/social_network_card.dart';
import 'package:rociny/features/influencer/profile/data/models/collaborated_company_model.dart';
import 'package:rociny/features/influencer/profile/data/models/influencer.dart';
import 'package:rociny/shared/widgets/influencer_pictures_card.dart';
import 'package:rociny/shared/widgets/instagram_statistics.dart';

class InfluencerProfile extends StatefulWidget {
  final Influencer influencer;
  final InstagramAccount? instagramAccount;
  final List<ReviewSummary> reviewSummaries;
  final List<CollaboratedCompany> collaboratedCompanies;
  const InfluencerProfile({
    super.key,
    required this.influencer,
    required this.instagramAccount,
    required this.reviewSummaries,
    required this.collaboratedCompanies,
  });

  @override
  State<InfluencerProfile> createState() => _InfluencerProfileState();
}

class _InfluencerProfileState extends State<InfluencerProfile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildPictures(),
        buildName(),
        buildGeolocation(),
        buildStars(),
        buildDescription(),
        buildSocialNetworks(),
        buildThemes(),
        buildTargetAudience(),
        buildInstagram(),
        buildReviewSummaries(),
        buildCollaboratedCompanies(),
      ],
    );
  }

  Widget buildPictures() {
    Influencer influencer = widget.influencer;
    if (influencer.profilePicture == null && influencer.portfolio.isEmpty) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding30, right: kPadding20, left: kPadding20),
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

    return Padding(
      padding: const EdgeInsets.only(right: kPadding20, left: kPadding20),
      child: Text(
        influencer.name!,
        style: kHeadline5Bold,
      ),
    );
  }

  Widget buildThemes() {
    Influencer influencer = widget.influencer;
    final List<String> themes = influencer.themes;

    if (themes.isEmpty) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding30, right: kPadding20, left: kPadding20),
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
      padding: const EdgeInsets.only(bottom: kPadding30, right: kPadding20, left: kPadding20),
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
      padding: const EdgeInsets.only(bottom: kPadding5, right: kPadding20, left: kPadding20),
      child: Text(
        influencer.department!,
        style: kBody.copyWith(color: kGrey300),
      ),
    );
  }

  Widget buildStars() {
    Influencer influencer = widget.influencer;

    return Padding(
      padding: const EdgeInsets.only(right: kPadding20, left: kPadding20, bottom: kPadding20),
      child: Row(
        children: [
          SvgPicture.asset(
            "assets/svg/star.svg",
            width: 15,
            height: 15,
            colorFilter: ColorFilter.mode(kBlack, BlendMode.srcIn),
          ),
          const SizedBox(width: kPadding5),
          Text(
            formatAverage(),
            style: kBody,
          ),
          const SizedBox(width: kPadding5),
          Container(
            height: 2,
            width: 2,
            decoration: BoxDecoration(
              color: kBlack,
              borderRadius: BorderRadius.circular(kRadius100),
            ),
          ),
          const SizedBox(width: kPadding5),
          Text(
            "${influencer.collaborationAmount.toString()} Collaborations",
            style: kBody,
          ),
        ],
      ),
    );
  }

  Widget buildDescription() {
    Influencer influencer = widget.influencer;

    if (influencer.description == null) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding20, right: kPadding20, left: kPadding20),
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
      padding: const EdgeInsets.only(bottom: kPadding30, right: kPadding20, left: kPadding20),
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
      padding: const EdgeInsets.only(bottom: kPadding30, right: kPadding20, left: kPadding20),
      child: InstagramStatistics(
        instagramAccount: widget.instagramAccount!,
      ),
    );
  }

  Widget buildReviewSummaries() {
    List<ReviewSummary> reviewSummaries = widget.reviewSummaries;

    if (reviewSummaries.isEmpty) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPadding20),
            child: Text("comments".translate(), style: kTitle1Bold),
          ),
          const SizedBox(height: kPadding20),
          LayoutBuilder(builder: (context, constraints) {
            return SizedBox(
              height: constraints.maxWidth / 2,
              width: constraints.maxWidth,
              child: ListView.builder(
                itemCount: reviewSummaries.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final r = reviewSummaries[index];
                  bool islast = index == reviewSummaries.length - 1;
                  return Padding(
                    padding: EdgeInsets.only(left: kPadding20, right: islast ? kPadding20 : 0),
                    child: Container(
                      height: double.infinity,
                      width: constraints.maxWidth - 60,
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(kRadius10),
                        border: Border.all(
                          color: kGrey100,
                          width: 0.5,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(kPadding20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(kRadius5),
                                ),
                                child: Image(
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(
                                    "$kEndpoint/company/profile-pictures/${r.profilePicture}",
                                    headers: {"Authorization": "Bearer $kJwt"},
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: kPadding10),
                            Text(
                              r.name,
                              style: kBodyBold,
                            ),
                            const SizedBox(height: kPadding20),
                            Expanded(
                              child: Text(
                                r.description,
                                style: kBody.copyWith(color: kGrey500),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 100,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          })
        ],
      ),
    );
  }

  Widget buildCollaboratedCompanies() {
    List<CollaboratedCompany> collaboratedCompanies = widget.collaboratedCompanies;

    if (collaboratedCompanies.isEmpty) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPadding20),
            child: Text("brands".translate(), style: kTitle1Bold),
          ),
          const SizedBox(height: kPadding20),
          LayoutBuilder(builder: (context, constraints) {
            return SizedBox(
              height: constraints.maxWidth / 2,
              width: constraints.maxWidth,
              child: ListView.builder(
                itemCount: collaboratedCompanies.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final r = collaboratedCompanies[index];
                  bool islast = index == collaboratedCompanies.length - 1;

                  return Padding(
                    padding: EdgeInsets.only(left: kPadding20, right: islast ? kPadding20 : 0),
                    child: Container(
                      height: double.infinity,
                      width: constraints.maxWidth - 60,
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(kRadius10),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(kRadius5),
                        ),
                        child: Image(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            "$kEndpoint/company/profile-pictures/${r.profilePicture}",
                            headers: {"Authorization": "Bearer $kJwt"},
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          })
        ],
      ),
    );
  }

  String formatAverage() {
    double value = widget.influencer.averageStars;

    if (value == 0) {
      return "Aucune notation";
    }

    if (value % 1 == 0) {
      return value.toInt().toString();
    } else {
      return value.toStringAsFixed(1);
    }
  }
}
