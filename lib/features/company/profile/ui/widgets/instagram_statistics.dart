import 'package:flutter/material.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/company/profile/ui/widgets/bar_chart.dart';
import 'package:rociny/features/company/profile/ui/widgets/donut_chart.dart';

/// TODO implement algo insta et mettre à jour profil (faire un "je suis disponible" comme malt, qui refresh les stats)
class InstagramStatistics extends StatelessWidget {
  /// prend des statistiques (doit marcher pour finluecneur et entreprise) = instagram_account model
  const InstagramStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "statistics".translate(),
          style: kTitle1Bold,
        ),
        Text(
          "stats_last_30_days".translate(),
          style: kCaption.copyWith(
            color: kGrey300,
          ),
        ),
        const SizedBox(height: kPadding20),
        buildFollowers(),
        const SizedBox(height: kPadding20),
        buildImpressions(),
        const SizedBox(height: kPadding20),
        buildGender(),
        const SizedBox(height: kPadding20),
        buildCities(),
        const SizedBox(height: kPadding20),
        buildAgeRanges(),
      ],
    );
  }

  Widget buildFollowers() {
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
              percent: 0.50,
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
              Text("439", style: kHeadline5Bold),
              const SizedBox(height: kPadding5),
              Text(
                "accounts_reached",
                style: kCaption.copyWith(color: kGrey300),
              ),
              const SizedBox(height: kPadding10),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("51,2%", style: kBodyBold),
                      const SizedBox(height: kPadding5),
                      Row(
                        children: [
                          Text("Followers", style: kCaption.copyWith(color: kGrey300)),
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
                  const SizedBox(width: kPadding10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("48,8%", style: kBodyBold),
                      const SizedBox(height: kPadding5),
                      Row(
                        children: [
                          Text("non_followers".translate(), style: kCaption.copyWith(color: kGrey300)),
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

  Widget buildImpressions() {
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
                  "1300",
                  style: kHeadline5Bold,
                ),
                const SizedBox(height: kPadding5),
                Text(
                  "impressions".translate(),
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
                  "650",
                  style: kHeadline5Bold,
                ),
                const SizedBox(height: kPadding5),
                Text(
                  "Interactions".translate(),
                  style: kCaption.copyWith(color: kGrey300),
                ),
              ],
            ),
          ),
        ),
      ],
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
              percent: 0.74,
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
                    "74 %",
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
                    "26 %",
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
    List<String> cities = ["Paris", "Mante-la-jolie", "Limay", "Yvelines", "Bondoufle"];
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
    List<String> ranges = ["13-17", "18-24", "25-34", "35-44", "45-54"];
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
}
