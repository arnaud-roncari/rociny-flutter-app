import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/company/search/bloc/preview/preview_bloc.dart';
import 'package:rociny/features/company/search/ui/widgets/company_warning_modal.dart';
import 'package:rociny/features/company/search/ui/widgets/influencer_warning_modal.dart';
import 'package:rociny/features/influencer/complete_profile/ui/widgets/social_network_card.dart';
import 'package:rociny/shared/widgets/button.dart';
import 'package:rociny/shared/widgets/influencer_pictures_card.dart';
import 'package:rociny/shared/widgets/instagram_statistics.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

/// TODO MAJ collab et review
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

            if (state is InitializeLoading) {
              return Center(
                child: CircularProgressIndicator(color: kPrimary500),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPadding20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: kPadding20),
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
                      Text("${bloc.influencer.name}", style: kTitle1Bold),
                      const Spacer(),
                      const SizedBox(width: kPadding20),
                    ],
                  ),
                  const SizedBox(height: kPadding15),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: kPadding15),
                          buildPictures(),
                          buildName(),
                          buildGeolocation(),
                          buildDescription(),
                          buildSocialNetworks(),
                          buildThemes(),
                          buildTargetAudience(),
                          buildInstagram(),
                          Button(
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
                          const SizedBox(height: kPadding20),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildPictures() {
    final bloc = context.read<PreviewBloc>();
    if (!bloc.influencerProfileCompletion.hasProfilePicture && !bloc.influencerProfileCompletion.hasPortofolio) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding30),
      child: InfluencerPicturesCard(
        influencer: bloc.influencer,
      ),
    );
  }

  Widget buildName() {
    final bloc = context.read<PreviewBloc>();
    if (!bloc.influencerProfileCompletion.hasName) {
      return Container();
    }

    return Text(
      bloc.influencer.name!,
      style: kHeadline5Bold,
    );
  }

  Widget buildThemes() {
    final bloc = context.read<PreviewBloc>();
    final List<String> themes = bloc.influencer.themes;
    if (!bloc.influencerProfileCompletion.hasThemes) {
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
                      themes[index],
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
    final bloc = context.read<PreviewBloc>();
    final List<String> ta = bloc.influencer.targetAudience;
    if (!bloc.influencerProfileCompletion.hasTargetAudience) {
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
    final bloc = context.read<PreviewBloc>();
    if (!bloc.influencerProfileCompletion.hasDepartment) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding5),
      child: Text(
        bloc.influencer.department!,
        style: kBody.copyWith(color: kGrey300),
      ),
    );
  }

  Widget buildDescription() {
    final bloc = context.read<PreviewBloc>();
    if (!bloc.influencerProfileCompletion.hasDescription) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding20),
      child: Text(
        bloc.influencer.description!,
        style: kBody,
      ),
    );
  }

  Widget buildSocialNetworks() {
    final bloc = context.read<PreviewBloc>();
    if (!bloc.influencerProfileCompletion.hasSocialNetworks) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: bloc.influencer.socialNetworks.map((sn) {
          return SocialNetworkCard(socialNetwork: sn);
        }).toList(),
      ),
    );
  }

  Widget buildInstagram() {
    final bloc = context.read<PreviewBloc>();
    if (!bloc.influencerProfileCompletion.hasInstagramAccount) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding30),
      child: InstagramStatistics(
        instagramAccount: bloc.instagramAccount!,
      ),
    );
  }
}
