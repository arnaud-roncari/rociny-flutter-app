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
import 'package:rociny/features/company/profile/data/models/company.dart';
import 'package:rociny/features/company/profile/data/models/review_summary.dart';
import 'package:rociny/features/company/search/data/models/influencer_summary_model.dart';
import 'package:rociny/features/company/search/ui/widgets/influencer_summary_card.dart';
import 'package:rociny/features/influencer/complete_profile/ui/widgets/social_network_card.dart';
import 'package:rociny/shared/widgets/instagram_statistics.dart';

class CompanyProfile extends StatefulWidget {
  final Company company;
  final InstagramAccount? instagramAccount;
  final List<ReviewSummary> reviewSummaries;
  final List<InfluencerSummary> collaboratedInfluencers;
  const CompanyProfile({
    super.key,
    required this.company,
    this.instagramAccount,
    required this.reviewSummaries,
    required this.collaboratedInfluencers,
  });

  @override
  State<CompanyProfile> createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildProfilePicture(),
        buildName(),
        buildGeolocation(),
        buildStars(),
        buildDescription(),
        buildSocialNetworks(),
        buildInstagram(),
        buildReviewSummaries(),
        buildCollaboratedInfluencers(),
      ],
    );
  }

  Widget buildProfilePicture() {
    final Company company = widget.company;

    if (company.profilePicture == null) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding30, right: kPadding20, left: kPadding20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kRadius10),
            ),
            width: constraints.maxWidth,
            height: constraints.maxWidth / 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(kRadius10),
              child: Image(
                image: NetworkImage(
                  "$kEndpoint/company/profile-pictures/${company.profilePicture!}",
                  headers: {
                    'Authorization': 'Bearer $kJwt',
                  },
                ),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildName() {
    final Company company = widget.company;

    if (company.name == null) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(right: kPadding20, left: kPadding20),
      child: Text(
        company.name!,
        style: kHeadline5Bold,
      ),
    );
  }

  Widget buildGeolocation() {
    final Company company = widget.company;

    if (company.department == null) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding5, right: kPadding20, left: kPadding20),
      child: Text(
        company.department!,
        style: kBody.copyWith(color: kGrey300),
      ),
    );
  }

  Widget buildStars() {
    Company company = widget.company;

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
            "${company.collaborationAmount.toString()} Collaborations",
            style: kBody,
          ),
        ],
      ),
    );
  }

  Widget buildDescription() {
    final Company company = widget.company;

    if (company.description == null) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding20, right: kPadding20, left: kPadding20),
      child: Text(
        company.description!,
        style: kBody,
      ),
    );
  }

  Widget buildSocialNetworks() {
    final Company company = widget.company;

    if (company.socialNetworks.isEmpty) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding30, right: kPadding20, left: kPadding20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: company.socialNetworks.map((sn) {
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

  Widget buildCollaboratedInfluencers() {
    List<InfluencerSummary> collaboratedInfluencers = widget.collaboratedInfluencers;

    if (collaboratedInfluencers.isEmpty) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPadding20),
            child: Text("Collaborations", style: kTitle1Bold),
          ),
          const SizedBox(height: kPadding20),
          LayoutBuilder(builder: (context, constraints) {
            return SizedBox(
              height: constraints.maxWidth,
              width: constraints.maxWidth,
              child: ListView.builder(
                itemCount: collaboratedInfluencers.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final r = collaboratedInfluencers[index];
                  bool islast = index == collaboratedInfluencers.length - 1;
                  return Padding(
                    padding: EdgeInsets.only(left: kPadding20, right: islast ? kPadding20 : 0),
                    child: Container(
                      height: double.infinity,
                      width: constraints.maxWidth - 60,
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(kRadius10),
                      ),
                      child: InfluencerSummaryCard(
                        influencer: r,
                        onPressed: (_) {},
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
                                    "$kEndpoint/influencer/profile-pictures/${r.profilePicture}",
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

  String formatAverage() {
    double value = widget.company.averageStars;

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
