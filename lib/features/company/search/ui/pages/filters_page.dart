import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/company/search/bloc/search/search_bloc.dart';
import 'package:rociny/features/company/search/ui/widgets/engagment_range_slider.dart';
import 'package:rociny/features/company/search/ui/widgets/followers_range_slider.dart';
import 'package:rociny/features/company/search/ui/widgets/tag_field.dart';
import 'package:rociny/shared/widgets/button.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

class FiltersPage extends StatelessWidget {
  const FiltersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SearchBloc>();
    final filters = bloc.filters;
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kPadding20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  Text(
                    "search".translate(),
                    style: kTitle1Bold,
                  ),
                  const Spacer(),
                  const SizedBox(width: kPadding20),
                ],
              ),
              const SizedBox(height: kPadding30),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("topic".translate(), style: kTitle1Bold),
                      const SizedBox(height: kPadding10),
                      Text(
                        "choose_topics".translate(),
                        style: kBody.copyWith(color: kGrey300),
                      ),
                      TagsField(
                        hint: "topic".translate(),
                        initialValues: filters.themes,
                        values: kThemes,
                        onUpdated: (themes) {
                          filters.themes = themes;
                        },
                      ),
                      const SizedBox(height: kPadding30),
                      Text("region".translate(), style: kTitle1Bold),
                      const SizedBox(height: kPadding10),
                      Text(
                        "target_department".translate(),
                        style: kBody.copyWith(color: kGrey300),
                      ),
                      TagsField(
                        hint: "department".translate(),
                        initialValues: filters.departments,
                        values: kDepartments,
                        onUpdated: (departments) {
                          filters.departments = departments;
                        },
                      ),
                      const SizedBox(height: kPadding30),
                      Text("age_ranges".translate(), style: kTitle1Bold),
                      const SizedBox(height: kPadding10),
                      Text(
                        "choose_age_ranges".translate(),
                        style: kBody.copyWith(color: kGrey300),
                      ),
                      TagsField(
                        hint: "age_ranges".translate(),
                        initialValues: filters.ages,
                        values: kAgeRanges,
                        onUpdated: (ages) {
                          filters.ages = ages;
                        },
                      ),
                      const SizedBox(height: kPadding30),
                      Text("target".translate(), style: kTitle1Bold),
                      const SizedBox(height: kPadding10),
                      Text(
                        "choose_targets".translate(),
                        style: kBody.copyWith(color: kGrey300),
                      ),
                      TagsField(
                        hint: "target".translate(),
                        initialValues: filters.targets,
                        values: kTargetAudiences,
                        onUpdated: (targets) {
                          filters.targets = targets;
                        },
                      ),
                      const SizedBox(height: kPadding30),
                      Text("audience".translate(), style: kTitle1Bold),
                      const SizedBox(height: kPadding10),
                      Text(
                        "define_audience".translate(),
                        style: kBody.copyWith(color: kGrey300),
                      ),
                      const SizedBox(height: kPadding20),
                      FollowersRangeSlider(
                        initialMax: filters.followersRange.last,
                        initialMin: filters.followersRange.first,
                        onChanged: (min, max) {
                          filters.followersRange = [min, max];
                        },
                      ),
                      const SizedBox(height: kPadding30),
                      Text("engagement_rate".translate(), style: kTitle1Bold),
                      const SizedBox(height: kPadding10),
                      Text(
                        "define_engagement_rate".translate(),
                        style: kBody.copyWith(color: kGrey300),
                      ),
                      const SizedBox(height: kPadding20),
                      EngagementRangeSlider(
                        initialMax: filters.engagementRateRange.last,
                        initialMin: filters.engagementRateRange.first,
                        onChanged: (min, max) {
                          filters.engagementRateRange = [min, max];
                        },
                      ),
                      const SizedBox(height: kPadding30),
                      Button(
                          title: "search_button".translate(),
                          onPressed: () {
                            context.read<SearchBloc>().add(GetInfluencersByFilters());
                            context.push('/company/home/filters/results');
                          })
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
