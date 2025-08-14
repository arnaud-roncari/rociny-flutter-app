import 'package:flutter/material.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/auth/data/models/instagram_account_model.dart';
import 'package:rociny/shared/widgets/bar_chart.dart';
import 'package:rociny/shared/widgets/donut_chart.dart';
import 'package:rociny/shared/widgets/horizontal_chart.dart';

class InstagramStatistics extends StatelessWidget {
  final InstagramAccount instagramAccount;
  const InstagramStatistics({super.key, required this.instagramAccount});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "statistics".translate(),
          style: kTitle1Bold,
        ),
        const SizedBox(height: kPadding10),
        Text(
          "stats_last_30_days".translate(),
          style: kCaption.copyWith(
            color: kGrey300,
          ),
        ),
        const SizedBox(height: kPadding20),
        buildFollowers(),
        const SizedBox(height: kPadding20),
        buildViews(),
        const SizedBox(height: kPadding20),
        buildInterest(),
        const SizedBox(height: kPadding20),
        buildEngagment(),
        const SizedBox(height: kPadding20),
        buildInteractions(),
        const SizedBox(height: kPadding20),
        buildPercentageContent(),
        const SizedBox(height: kPadding20),
        buildGender(),
        const SizedBox(height: kPadding20),
        buildCities(),
        const SizedBox(height: kPadding20),
        buildAgeRanges(),
      ],
    );
  }

  Widget buildInterest() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: kGrey100),
        borderRadius: BorderRadius.circular(kRadius10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(kPadding20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              "profile_interest".translate(),
              style: kBodyBold,
            ),
            const SizedBox(height: kPadding20),
            Row(
              children: [
                Text(
                  "profile_view_rate".translate(),
                  style: kCaption.copyWith(color: kGrey300),
                ),
                const Spacer(),
                Text(
                  "${instagramAccount.profileViewRate!.toStringAsFixed(0)} %",
                  style: kCaption,
                ),
              ],
            ),
            const SizedBox(height: kPadding20),
            Row(
              children: [
                Text(
                  "profile_views".translate(),
                  style: kCaption.copyWith(color: kGrey300),
                ),
                const Spacer(),
                Text(
                  instagramAccount.profileViews.toString(),
                  style: kCaption,
                ),
              ],
            ),
            const SizedBox(height: kPadding20),
            Row(
              children: [
                Text(
                  "website_clicks".translate(),
                  style: kCaption.copyWith(color: kGrey300),
                ),
                const Spacer(),
                Text(
                  instagramAccount.websiteClicks.toString(),
                  style: kCaption,
                ),
              ],
            ),
            const SizedBox(height: kPadding20),
            Row(
              children: [
                Text(
                  "link_clicks".translate(),
                  style: kCaption.copyWith(color: kGrey300),
                ),
                const Spacer(),
                Text(
                  instagramAccount.linkClicks.toString(),
                  style: kCaption,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInteractions() {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: kGrey100),
        borderRadius: BorderRadius.circular(kRadius10),
      ),
      child: Row(
        children: [
          const SizedBox(width: kPadding20),
          SizedBox(
            height: 80,
            width: 80,
            child: DonutChart(
              percent: instagramAccount.interactionPercentagePosts! / 100,
              primaryColor: kPrimary500,
              secondaryColor: kGrey100,
              gapDegree: 5,
              strokeWidth: 10,
            ),
          ),
          const SizedBox(width: kPadding20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(instagramAccount.totalInteractions.toString(), style: kHeadline5Bold),
              const SizedBox(height: kPadding5),
              Text(
                "total_interactions".translate(),
                style: kCaption.copyWith(color: kGrey300),
              ),
              const SizedBox(height: kPadding10),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${instagramAccount.interactionPercentagePosts!.toStringAsFixed(0)} %",
                        style: kBodyBold,
                      ),
                      const SizedBox(height: kPadding5),
                      Row(
                        children: [
                          Text(
                            "Posts",
                            style: kCaption.copyWith(color: kGrey300),
                          ),
                          const SizedBox(width: kPadding5),
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: kPrimary500,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: kPadding20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${instagramAccount.interactionPercentageReels!.toStringAsFixed(0)} %", style: kBodyBold),
                      const SizedBox(height: kPadding5),
                      Row(
                        children: [
                          Text("Reels", style: kCaption.copyWith(color: kGrey300)),
                          const SizedBox(width: kPadding5),
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: kGrey300,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: kPadding20),
        ],
      ),
    );
  }

  Widget buildViews() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 75,
            decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: kGrey100),
              borderRadius: BorderRadius.circular(kRadius10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  instagramAccount.views.toString(),
                  style: kHeadline5Bold,
                ),
                const SizedBox(height: kPadding5),
                Text(
                  "views".translate(),
                  style: kCaption.copyWith(color: kGrey300),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: kPadding10),
        Expanded(
          child: Container(
            height: 75,
            decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: kGrey100),
              borderRadius: BorderRadius.circular(kRadius10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  instagramAccount.reach.toString(),
                  style: kHeadline5Bold,
                ),
                const SizedBox(height: kPadding5),
                Text(
                  "reach".translate(),
                  style: kCaption.copyWith(color: kGrey300),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildFollowers() {
    return Container(
      height: 75,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: kGrey100),
        borderRadius: BorderRadius.circular(kRadius10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            instagramAccount.followersCount.toString(),
            style: kHeadline5Bold,
          ),
          const SizedBox(height: kPadding5),
          Text(
            "followers".translate(),
            style: kCaption.copyWith(color: kGrey300),
          ),
        ],
      ),
    );
  }

  Widget buildEngagment() {
    return Container(
      height: 75,
      width: double.infinity,
      decoration: BoxDecoration(
        color: kPrimary500,
        borderRadius: BorderRadius.circular(kRadius10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${instagramAccount.engagementRate!.toStringAsFixed(0)} %",
            style: kHeadline5Bold.copyWith(color: kWhite),
          ),
          const SizedBox(height: kPadding5),
          Text(
            "engagement_rate".translate(),
            style: kCaption.copyWith(color: kWhite),
          ),
        ],
      ),
    );
  }

  Widget buildGender() {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: kGrey100),
        borderRadius: BorderRadius.circular(kRadius10),
      ),
      child: Row(
        children: [
          const SizedBox(width: kPadding20),
          SizedBox(
            height: 80,
            width: 80,
            child: BarChart(
              percent: instagramAccount.genderMalePercentage! / 100,
              primaryColor: kPrimary500,
              secondaryColor: kPrimary400,
            ),
          ),
          const Spacer(),

          ///
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${instagramAccount.genderMalePercentage!.toStringAsFixed(0)} %",
                    style: kHeadline5Bold,
                  ),
                  const SizedBox(height: kPadding5),
                  Row(
                    children: [
                      Text(
                        "men".translate(),
                        style: kCaption.copyWith(color: kGrey300),
                      ),
                      const SizedBox(width: kPadding5),
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: kPrimary500,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: kPadding20),
              Container(
                height: 50,
                width: 0.5,
                color: kGrey100,
              ),
              const SizedBox(width: kPadding20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${instagramAccount.genderFemalePercentage!.toStringAsFixed(0)} %",
                    style: kHeadline5Bold,
                  ),
                  const SizedBox(height: kPadding5),
                  Row(
                    children: [
                      Text(
                        "women".translate(),
                        style: kCaption.copyWith(color: kGrey300),
                      ),
                      const SizedBox(width: kPadding5),
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: kPrimary400,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          const SizedBox(width: kPadding20),
        ],
      ),
    );
  }

  Widget buildCities() {
    List<String> cities = instagramAccount.topCities!;
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: kGrey100),
        borderRadius: BorderRadius.circular(kRadius10),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: kPadding20, bottom: kPadding20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: kPadding20),
              child: Text(
                "top_cities".translate(),
                style: kTitle2Bold,
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 30,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: cities.length,
                separatorBuilder: (context, index) => const SizedBox(width: kPadding10),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(left: index == 0 ? kPadding20 : 0),
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        color: kPrimary500,
                        borderRadius: BorderRadius.circular(kRadius100),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: kPadding10),
                          child: Text(
                            cities[index],
                            style: kCaptionBold.copyWith(color: kWhite),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAgeRanges() {
    List<String> ranges = instagramAccount.topAgeRanges!;
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: kGrey100),
        borderRadius: BorderRadius.circular(kRadius10),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: kPadding20, bottom: kPadding20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: kPadding20),
              child: Text(
                "age_range".translate(),
                style: kTitle2Bold,
              ),
            ),
            const Spacer(),
            SizedBox(
              height: 30,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: ranges.length,
                separatorBuilder: (context, index) => const SizedBox(width: kPadding10),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(left: index == 0 ? kPadding20 : 0),
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        color: kPrimary500,
                        borderRadius: BorderRadius.circular(kRadius100),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: kPadding10),
                          child: Text(
                            ranges[index],
                            style: kCaptionBold.copyWith(color: kWhite),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPercentageContent() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: kGrey100),
        borderRadius: BorderRadius.circular(kRadius10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(kPadding20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              "content_type".translate(),
              style: kBodyBold,
            ),
            const SizedBox(height: kPadding20),
            Text(
              "Posts",
              style: kCaption,
            ),
            const SizedBox(height: kPadding10),
            Row(
              children: [
                Expanded(
                  child: HorizontalChart(
                    percent: instagramAccount.postPercentage! / 100,
                  ),
                ),
                const SizedBox(width: kPadding20),
                SizedBox(
                  width: 40,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "${instagramAccount.postPercentage!.toStringAsFixed(0)} %",
                      style: kCaption,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: kPadding20),
            Text(
              "Reels",
              style: kCaption,
            ),
            const SizedBox(height: kPadding10),
            Row(
              children: [
                Expanded(
                  child: HorizontalChart(
                    percent: instagramAccount.reelPercentage! / 100,
                  ),
                ),
                const SizedBox(width: kPadding20),
                SizedBox(
                  width: 40,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "${instagramAccount.reelPercentage!.toStringAsFixed(0)} %",
                      style: kCaption,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
