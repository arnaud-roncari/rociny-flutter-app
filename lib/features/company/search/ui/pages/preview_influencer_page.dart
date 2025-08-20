import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/features/company/search/bloc/preview/preview_bloc.dart';
import 'package:rociny/features/company/search/ui/widgets/company_warning_modal.dart';
import 'package:rociny/features/company/search/ui/widgets/influencer_warning_modal.dart';
import 'package:rociny/features/influencer/profile/ui/widgets/influencer_profile.dart';
import 'package:rociny/shared/widgets/button.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

class PreviewInfluencerPage extends StatefulWidget {
  final int userId;
  const PreviewInfluencerPage({super.key, required this.userId});

  @override
  State<PreviewInfluencerPage> createState() => _PreviewInfluencerPageState();
}

class _PreviewInfluencerPageState extends State<PreviewInfluencerPage> {
  @override
  void initState() {
    super.initState();
    context.read<PreviewBloc>().add(Initialize(userId: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: BlocConsumer<PreviewBloc, PreviewState>(
          listener: (context, state) {
            if (state is InitializeFailed) {
              Alert.showError(context, state.exception.message);
            }
          },
          builder: (context, state) {
            final bloc = context.read<PreviewBloc>();

            if (state is InitializeLoading || state is InitializeFailed) {
              return Center(
                child: CircularProgressIndicator(color: kPrimary500),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: kPadding20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kPadding20),
                  child: Row(
                    children: [
                      SvgButton(
                        path: "assets/svg/left_arrow.svg",
                        color: kBlack,
                        onPressed: () {
                          context.pop();
                        },
                      ),
                      const Spacer(),
                      Text("Influenceur", style: kTitle1Bold),
                      const Spacer(),
                      const SizedBox(width: kPadding20),
                    ],
                  ),
                ),
                const SizedBox(height: kPadding15),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: kPadding15),
                        InfluencerProfile(
                          influencer: bloc.influencer,
                          instagramAccount: bloc.instagramAccount,
                          reviewSummaries: bloc.reviewSummaries,
                          collaboratedCompanies: bloc.collaboratedCompanies,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: kPadding20),
                          child: Button(
                            title: "Proposer une collaboration",
                            onPressed: () async {
                              if (!bloc.companyProfileCompletion.isCompleted()) {
                                showModalBottomSheet(
                                  context: context,
                                  isDismissible: false,
                                  backgroundColor: kWhite,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(kRadius20)),
                                  ),
                                  builder: (BuildContext context) {
                                    return const CompanyWarningModal();
                                  },
                                );
                              } else if (!bloc.influencerProfileCompletion.isCompleted()) {
                                showModalBottomSheet(
                                  context: context,
                                  isDismissible: false,
                                  backgroundColor: kWhite,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(kRadius20)),
                                  ),
                                  builder: (BuildContext context) {
                                    return const InfluencerWarningModal();
                                  },
                                );
                              } else {
                                context.push("/company/home/preview/create/collaboration");
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: kPadding20),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
