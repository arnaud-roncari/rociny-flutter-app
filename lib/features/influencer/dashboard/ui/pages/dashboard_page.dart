import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/influencer/collaborations/ui/widgets/collaboration_summary_card.dart';
import 'package:rociny/features/influencer/dashboard/bloc/dashboard_bloc.dart';
import 'package:rociny/shared/decorations/container_shadow_decoration.dart';

/// TODO bug lors de vpreiw compan,y depuis collaboration
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    context.read<DashboardBloc>().add(Initialize());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPadding20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: kPadding20),
          Text(
            "dashboard".translate(),
            style: kHeadline4Bold,
          ),
          const SizedBox(height: kPadding15),
          Expanded(
            child: BlocConsumer<DashboardBloc, DashboardState>(
              listener: (context, state) {
                if (state is InitializeFailed) {
                  Alert.showError(context, state.exception.message);
                }
              },
              builder: (context, state) {
                if (state is InitializeFailed || state is InitializeLoading) {
                  return Column(
                    children: [
                      const Spacer(),
                      Center(
                        child: CircularProgressIndicator(
                          color: kPrimary500,
                        ),
                      ),
                      const Spacer(),
                    ],
                  );
                }

                final stats = context.read<DashboardBloc>().statistics;

                return LayoutBuilder(builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: kPadding15),
                        Text(
                          "Statistiques",
                          style: kTitle1Bold,
                        ),
                        const SizedBox(height: kPadding5),
                        Text(
                          "Statistiques basées sur les 30 derniers jours",
                          style: kCaption.copyWith(color: kGrey300),
                        ),
                        const SizedBox(height: kPadding20),
                        Container(
                          height: 110,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(kRadius10),
                            color: kPrimary500,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(kPadding20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  "assets/svg/folder.svg",
                                  width: 20,
                                  height: 20,
                                  colorFilter: ColorFilter.mode(kWhite, BlendMode.srcIn),
                                ),
                                const Spacer(),
                                Text(
                                  "Revenus",
                                  style: kCaption.copyWith(color: kWhite),
                                ),
                                const SizedBox(height: kPadding5),
                                Text(
                                  "${stats.revenue} €",
                                  style: kHeadline5Bold.copyWith(color: kWhite),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: kPadding20),
                        Row(
                          children: [
                            Container(
                              height: 110,
                              width: (constraints.maxWidth / 2) - 10,
                              decoration: kContainerShadow,
                              child: Padding(
                                padding: const EdgeInsets.all(kPadding20),
                                child: Column(
                                  children: [
                                    const Spacer(),
                                    Text(
                                      stats.collaborationsCount.toString(),
                                      style: kHeadline5Bold,
                                    ),
                                    const SizedBox(height: kPadding5),
                                    Text(
                                      "Collaborations",
                                      style: kCaption.copyWith(color: kGrey300),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: kPadding20),
                            Container(
                              height: 110,
                              width: (constraints.maxWidth / 2) - 10,
                              decoration: kContainerShadow,
                              child: Padding(
                                padding: const EdgeInsets.all(kPadding20),
                                child: Column(
                                  children: [
                                    const Spacer(),
                                    Text(
                                      stats.placementsCount.toString(),
                                      style: kHeadline5Bold,
                                    ),
                                    const SizedBox(height: kPadding5),
                                    Text(
                                      "Placements",
                                      style: kCaption.copyWith(color: kGrey300),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: kPadding20),
                        Row(
                          children: [
                            Container(
                              height: 110,
                              width: (constraints.maxWidth / 2) - 10,
                              decoration: kContainerShadow,
                              child: Padding(
                                padding: const EdgeInsets.all(kPadding20),
                                child: Column(
                                  children: [
                                    const Spacer(),
                                    Text(
                                      stats.profileViews.toString(),
                                      style: kHeadline5Bold,
                                    ),
                                    const SizedBox(height: kPadding5),
                                    Text(
                                      "Visites du profil",
                                      style: kCaption.copyWith(color: kGrey300),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: kPadding20),
                            Container(
                              height: 110,
                              width: (constraints.maxWidth / 2) - 10,
                              decoration: kContainerShadow,
                              child: Padding(
                                padding: const EdgeInsets.all(kPadding20),
                                child: Column(
                                  children: [
                                    const Spacer(),
                                    Text(
                                      stats.averageRating.toStringAsFixed(1),
                                      style: kHeadline5Bold,
                                    ),
                                    const SizedBox(height: kPadding5),
                                    Text(
                                      "Notation",
                                      style: kCaption.copyWith(color: kGrey300),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Builder(builder: (context) {
                          final collaborations = context.read<DashboardBloc>().collaborations;
                          if (collaborations.isEmpty) {
                            return Container();
                          }

                          List<Widget> children = [];

                          for (var summary in collaborations) {
                            children.add(Padding(
                              padding: const EdgeInsets.only(bottom: kPadding20),
                              child: CollaborationSummaryCard(summary: summary),
                            ));
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: kPadding30),
                              Text("Collaborations", style: kTitle1Bold),
                              const SizedBox(height: kPadding5),
                              Text(
                                "Collaborations sur les 30 derniers jours",
                                style: kCaption.copyWith(color: kGrey300),
                              ),
                              const SizedBox(height: kPadding20),
                              ...children,
                              const SizedBox(height: kPadding20)
                            ],
                          );
                        }),
                      ],
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
