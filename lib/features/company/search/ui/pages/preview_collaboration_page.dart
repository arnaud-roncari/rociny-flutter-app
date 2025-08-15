import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/company/search/bloc/preview/preview_bloc.dart';
import 'package:rociny/features/company/search/data/models/influencer_summary_model.dart';
import 'package:rociny/features/company/search/data/models/product_placement_model.dart';
import 'package:rociny/features/company/search/ui/widgets/billing_informations.dart';
import 'package:rociny/features/company/search/ui/widgets/file_card.dart';
import 'package:rociny/features/company/search/ui/widgets/influencer_summary_card.dart';
import 'package:rociny/features/company/search/ui/widgets/product_placement_card.dart';
import 'package:rociny/shared/widgets/button.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

class PreviewCollaborationPage extends StatefulWidget {
  const PreviewCollaborationPage({super.key});

  @override
  State<PreviewCollaborationPage> createState() => _PreviewCollaborationPageState();
}

class _PreviewCollaborationPageState extends State<PreviewCollaborationPage> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PreviewBloc>();
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: BlocConsumer<PreviewBloc, PreviewState>(
          listener: (context, state) {
            if (state is CreateCollaborationSuccess) {
              Alert.showSuccess(context, "collaboration_sent".translate());
              context.go("/company/home");
            }

            if (state is CreateCollaborationFailed) {
              Alert.showError(context, state.exception.message);
            }
          },
          builder: (context, state) {
            if (state is CreateCollaborationLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: kPrimary500,
                ),
              );
            }

            return Column(
              children: [
                const SizedBox(height: kPadding20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kPadding20),
                  child: Row(
                    children: [
                      SvgButton(
                        path: 'assets/svg/left_arrow.svg',
                        color: kBlack,
                        onPressed: () {
                          context.pop();
                        },
                      ),
                      const Spacer(),
                      Text("preview".translate(), style: kTitle1Bold),
                      const Spacer(),
                      const SizedBox(width: kPadding20),
                    ],
                  ),
                ),
                const SizedBox(height: kPadding15),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: kPadding20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: kPadding15),
                              InfluencerSummaryCard(
                                influencer: InfluencerSummary.fromInfluencer(
                                  bloc.influencer,
                                  bloc.instagramAccount!,
                                ),
                                onPressed: (_) {},
                              ),
                              const SizedBox(height: kPadding30),
                              Text(
                                "placements".translate(),
                                style: kTitle1Bold,
                              ),
                              const SizedBox(height: kPadding10),
                              Text(
                                "placements_instruction".translate(),
                                style: kBody.copyWith(color: kGrey300),
                              ),
                            ],
                          ),
                        ),

                        Builder(builder: (context) {
                          List<Widget> children = [];
                          for (ProductPlacement pp in bloc.collaboration.productPlacements) {
                            children.add(
                              Padding(
                                padding: const EdgeInsets.only(left: kPadding20),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width - 60,
                                  child: ProductPlacementCard(
                                    productPlacement: pp,
                                  ),
                                ),
                              ),
                            );
                          }
                          children.add(const SizedBox(width: kPadding20));

                          return SizedBox(
                            height: 120,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: children,
                              ),
                            ),
                          );
                        }),

                        if (bloc.files.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: kPadding20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: kPadding10),
                                    Text(
                                      "file".translate(),
                                      style: kTitle1Bold,
                                    ),
                                    const SizedBox(height: kPadding10),
                                    Text(
                                      "file_instruction".translate(),
                                      style: kBody.copyWith(color: kGrey300),
                                    ),
                                  ],
                                ),
                              ),
                              Builder(
                                builder: (context) {
                                  final bloc = context.read<PreviewBloc>();
                                  List<Widget> children = [];
                                  for (File file in bloc.files) {
                                    children.add(
                                      Padding(
                                        padding: const EdgeInsets.only(left: kPadding20),
                                        child: SizedBox(
                                          width: MediaQuery.of(context).size.width - 60,
                                          child: FileCard(
                                            file: file,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  children.add(const SizedBox(width: kPadding20));

                                  return SizedBox(
                                    height: 120,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: children,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        const SizedBox(height: kPadding10),

                        buildBill(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: kPadding20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: kPadding30),
                              Button(
                                backgroundColor: kBlack,
                                title: "create_draft".translate(),
                                onPressed: () {
                                  bloc.add(CreateCollaboration(isDraft: true));
                                },
                              ),
                              const SizedBox(height: kPadding10),
                              Button(
                                title: "propose_collaboration".translate(),
                                onPressed: () {
                                  bloc.add(CreateCollaboration(isDraft: false));
                                },
                              ),
                            ],
                          ),
                        ),

                        /// ...
                        const SizedBox(height: kPadding20),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildBill() {
    final bloc = context.read<PreviewBloc>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPadding20),
      child: BillingInformations(
        collaboration: bloc.collaboration,
        company: bloc.company,
        influencer: bloc.influencer,
      ),
    );
  }
}
