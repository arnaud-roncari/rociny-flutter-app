import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/company/search/bloc/search/search_bloc.dart';
import 'package:rociny/features/company/search/ui/widgets/influencer_summary_card.dart';
import 'package:rociny/features/company/search/ui/widgets/sort_modal.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: BlocConsumer<SearchBloc, SearchState>(
          listener: (context, state) {
            if (state is GetInfluencersByFiltersFailed) {
              Alert.showError(context, state.exception.message);
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: kPadding20),
                buildSearchButton(),
                const SizedBox(height: kPadding20),
                Expanded(
                  child: Builder(builder: (context) {
                    final bloc = context.read<SearchBloc>();
                    if (state is GetInfluencersByFiltersLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: kPrimary500,
                        ),
                      );
                    }

                    if (bloc.influencers.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "no_results".translate(),
                              style: kBodyBold.copyWith(color: kGrey300),
                            ),
                            const SizedBox(height: kPadding5),
                            Text(
                              "no_matching_influencer".translate(),
                              style: kBody.copyWith(color: kGrey300),
                            ),
                          ],
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: kPadding20),
                      child: RefreshIndicator(
                        backgroundColor: kWhite,
                        elevation: 0,
                        color: kPrimary500,
                        onRefresh: () async {
                          bloc.add(GetInfluencersByFilters());
                        },
                        child: ListView.separated(
                          itemCount: bloc.influencers.length,
                          separatorBuilder: (context, index) => const SizedBox(height: kPadding20),
                          itemBuilder: (context, index) {
                            final influencer = bloc.influencers[index];
                            return InfluencerSummaryCard(influencer: influencer);
                          },
                        ),
                      ),
                    );
                  }),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildSearchButton() {
    final bloc = context.read<SearchBloc>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPadding20),
      child: Container(
        height: 40,
        width: double.infinity,
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(kRadius100),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: kBlack.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(kRadius100),
            onTap: () {
              context.pop();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPadding15),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      context.pop();
                      context.pop();
                    },
                    child: SvgPicture.asset(
                      "assets/svg/close.svg",
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(kGrey300, BlendMode.srcIn),
                    ),
                  ),
                  const SizedBox(width: kPadding15),
                  Expanded(
                    child: Text(
                      bloc.filters.summarise(),
                      style: kBody.copyWith(color: kGrey300),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: kPadding15),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return const SortModal();
                        },
                      );
                    },
                    child: SvgPicture.asset(
                      "assets/svg/sort.svg",
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(kGrey300, BlendMode.srcIn),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
