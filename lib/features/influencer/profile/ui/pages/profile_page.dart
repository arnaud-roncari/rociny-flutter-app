import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/shared/widgets/instagram_statistics.dart';
import 'package:rociny/features/influencer/complete_profile/ui/widgets/social_network_card.dart';
import 'package:rociny/features/influencer/profile/bloc/profile_bloc.dart';
import 'package:rociny/features/influencer/profile/data/models/profile_completion_status.dart';
import 'package:rociny/features/influencer/profile/ui/widgets/edit_modal.dart';
import 'package:rociny/features/influencer/profile/ui/widgets/warning_modal.dart';
import 'package:rociny/shared/widgets/chip_button.dart';
import 'package:rociny/shared/widgets/influencer_pictures_card.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

/// TODO afficher portfolio quand on clique sur une photo
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    context.read<ProfileBloc>().add(GetProfile());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is GetProfileFailed) {
          Alert.showError(context, state.exception.message);
        }

        if (state is ProfileUpdated) {
          Alert.showSuccess(context, "changes_saved".translate());
        }
      },
      builder: (context, state) {
        final bloc = context.read<ProfileBloc>();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPadding20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: kPadding20),
              Row(
                children: [
                  Text(
                    "profile".translate(),
                    style: kHeadline4Bold,
                  ),
                  const Spacer(),
                  buildWarning(),
                  SizedBox(
                    child: SvgButton(
                      path: "assets/svg/pen.svg",
                      color: kBlack,
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return const EditModal();
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: kPadding10),
                  SizedBox(
                    child: SvgButton(
                      path: "assets/svg/settings.svg",
                      color: kBlack,
                      onPressed: () {
                        context.push("/influencer/home/settings");
                      },
                    ),
                  )
                ],
              ),
              Expanded(
                child: Builder(builder: (context) {
                  if (state is GetProfileLoading || state is GetProfileFailed) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: kPrimary500,
                      ),
                    );
                  }

                  return RefreshIndicator(
                    backgroundColor: kWhite,
                    elevation: 0,
                    color: kPrimary500,
                    onRefresh: () async {
                      bloc.add(GetProfile());
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: kPadding30),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildAddProfilePicture(),
                              buildAddPortfolio(),
                              buildAddName(),
                              buildAddGeolocation(),
                              buildAddDescription(),
                              buildAddSocialNetworks(),
                              buildAddThemes(),
                              buildAddTargetAudience(),
                              buildAddInstagram(),
                            ],
                          ),
                          buildPictures(),
                          buildName(),
                          buildGeolocation(),
                          buildStars(),
                          buildDescription(),
                          buildSocialNetworks(),
                          buildThemes(),
                          buildTargetAudience(),
                          buildInstagram(),
                          buildComments(),
                          buildBrands(),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: kPadding20),
            ],
          ),
        );
      },
    );
  }

  /// ---

  Widget buildWarning() {
    final bloc = context.read<ProfileBloc>();
    ProfileCompletionStatus? status = bloc.profileCompletionStatus;
    if (status == null || status.isCompleted()) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(right: kPadding10),
      child: SizedBox(
        child: SvgButton(
            path: "assets/svg/warning.svg",
            color: kRed500,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return WarningModal(status: status);
                },
              );
            }),
      ),
    );
  }

  /// ---

  Widget buildAddProfilePicture() {
    final bloc = context.read<ProfileBloc>();
    if (!bloc.profileCompletionStatus!.hasProfilePicture) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("photo".translate(), style: kTitle1Bold),
          const SizedBox(height: kPadding10),
          Text(
            "publish_profile_photo".translate(),
            style: kBody.copyWith(color: kGrey300),
          ),
          const SizedBox(height: kPadding20),
          ChipButton(
            onTap: () {
              bloc.add(UpdateProfilePicture());
            },
            label: "add".translate(),
            svgPath: "assets/svg/cloud_upload.svg",
          ),
          const SizedBox(height: kPadding30),
        ],
      );
    }

    return Container();
  }

  Widget buildAddPortfolio() {
    final bloc = context.read<ProfileBloc>();
    if (!bloc.profileCompletionStatus!.hasPortofolio) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("add".translate(), style: kTitle1Bold),
          const SizedBox(height: kPadding10),
          Text(
            "publish_portfolio".translate(),
            style: kBody.copyWith(color: kGrey300),
          ),
          const SizedBox(height: kPadding20),
          ChipButton(
            onTap: () {
              context.push("/influencer/home/profile/portfolio");
            },
            label: "Portfolio",
            svgPath: "assets/svg/cloud_upload.svg",
          ),
          const SizedBox(height: kPadding30),
        ],
      );
    }

    return Container();
  }

  Widget buildPictures() {
    final bloc = context.read<ProfileBloc>();
    if (!bloc.profileCompletionStatus!.hasProfilePicture && !bloc.profileCompletionStatus!.hasPortofolio) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding30),
      child: InfluencerPicturesCard(
        influencer: bloc.influencer,
      ),
    );
  }

  Widget buildAddName() {
    final bloc = context.read<ProfileBloc>();
    if (!bloc.profileCompletionStatus!.hasName) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("name".translate(), style: kTitle1Bold),
          const SizedBox(height: kPadding10),
          Text(
            "set_influencer_name".translate(),
            style: kBody.copyWith(color: kGrey300),
          ),
          const SizedBox(height: kPadding20),
          ChipButton(
            onTap: () {
              context.push("/influencer/home/profile/name");
            },
            label: "define".translate(),
            svgPath: "assets/svg/add.svg",
          ),
          const SizedBox(height: kPadding30),
        ],
      );
    }

    return Container();
  }

  Widget buildName() {
    final bloc = context.read<ProfileBloc>();
    if (!bloc.profileCompletionStatus!.hasName) {
      return Container();
    }

    return Text(
      bloc.influencer.name!,
      style: kHeadline5Bold,
    );
  }

  Widget buildAddThemes() {
    final bloc = context.read<ProfileBloc>();
    if (!bloc.profileCompletionStatus!.hasThemes) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("themes".translate(), style: kTitle1Bold),
          const SizedBox(height: kPadding10),
          Text(
            "set_content_themes".translate(),
            style: kBody.copyWith(color: kGrey300),
          ),
          const SizedBox(height: kPadding20),
          ChipButton(
            onTap: () {
              context.push("/influencer/home/profile/themes");
            },
            label: "add".translate(),
            svgPath: "assets/svg/add.svg",
          ),
          const SizedBox(height: kPadding30),
        ],
      );
    }

    return Container();
  }

  Widget buildThemes() {
    final bloc = context.read<ProfileBloc>();
    final List<String> themes = bloc.influencer.themes;
    if (!bloc.profileCompletionStatus!.hasThemes) {
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

  Widget buildAddTargetAudience() {
    final bloc = context.read<ProfileBloc>();
    if (!bloc.profileCompletionStatus!.hasTargetAudience) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("targets".translate(), style: kTitle1Bold),
          const SizedBox(height: kPadding10),
          Text(
            "set_targets".translate(),
            style: kBody.copyWith(color: kGrey300),
          ),
          const SizedBox(height: kPadding20),
          ChipButton(
            onTap: () {
              context.push("/influencer/home/profile/target_audience");
            },
            label: "add".translate(),
            svgPath: "assets/svg/add.svg",
          ),
          const SizedBox(height: kPadding30),
        ],
      );
    }

    return Container();
  }

  Widget buildTargetAudience() {
    final bloc = context.read<ProfileBloc>();
    final List<String> ta = bloc.influencer.targetAudience;
    if (!bloc.profileCompletionStatus!.hasTargetAudience) {
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

  Widget buildAddGeolocation() {
    final bloc = context.read<ProfileBloc>();
    if (!bloc.profileCompletionStatus!.hasDepartment) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("geolocation".translate(), style: kTitle1Bold),
          const SizedBox(height: kPadding10),
          Text(
            "set_geolocation".translate(),
            style: kBody.copyWith(color: kGrey300),
          ),
          const SizedBox(height: kPadding20),
          ChipButton(
            onTap: () {
              context.push("/influencer/home/profile/geolocation");
            },
            label: "define".translate(),
            svgPath: "assets/svg/add.svg",
          ),
          const SizedBox(height: kPadding30),
        ],
      );
    }

    return Container();
  }

  Widget buildGeolocation() {
    final bloc = context.read<ProfileBloc>();
    if (!bloc.profileCompletionStatus!.hasDepartment) {
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

  Widget buildStars() {
    /// And  amount of collaboration
    // return Text("0 Collaborations", style: kBody);
    return Container();
  }

  Widget buildAddDescription() {
    final bloc = context.read<ProfileBloc>();
    if (!bloc.profileCompletionStatus!.hasDescription) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("description".translate(), style: kTitle1Bold),
          const SizedBox(height: kPadding10),
          Text(
            "set_description".translate(),
            style: kBody.copyWith(color: kGrey300),
          ),
          const SizedBox(height: kPadding20),
          ChipButton(
            onTap: () {
              context.push("/influencer/home/profile/description");
            },
            label: "define".translate(),
            svgPath: "assets/svg/add.svg",
          ),
          const SizedBox(height: kPadding30),
        ],
      );
    }

    return Container();
  }

  Widget buildDescription() {
    final bloc = context.read<ProfileBloc>();
    if (!bloc.profileCompletionStatus!.hasDescription) {
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

  Widget buildAddSocialNetworks() {
    final bloc = context.read<ProfileBloc>();
    if (!bloc.profileCompletionStatus!.hasSocialNetworks) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("social_networks".translate(), style: kTitle1Bold),
          const SizedBox(height: kPadding10),
          Text(
            "highlight_social_networks".translate(),
            style: kBody.copyWith(color: kGrey300),
          ),
          const SizedBox(height: kPadding20),
          ChipButton(
            onTap: () {
              context.push("/influencer/home/profile/social_networks");
            },
            label: "add".translate(),
            svgPath: "assets/svg/add.svg",
          ),
          const SizedBox(height: kPadding30),
        ],
      );
    }

    return Container();
  }

  Widget buildSocialNetworks() {
    final bloc = context.read<ProfileBloc>();
    if (!bloc.profileCompletionStatus!.hasSocialNetworks) {
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

  Widget buildAddInstagram() {
    final bloc = context.read<ProfileBloc>();
    if (!bloc.profileCompletionStatus!.hasInstagramAccount) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("statistics".translate(), style: kTitle1Bold),
          const SizedBox(height: kPadding10),
          Text(
            "link_instagram".translate(),
            style: kBody.copyWith(color: kGrey300),
          ),
          const SizedBox(height: kPadding20),
          ChipButton(
            onTap: () async {
              await context.push('/influencer/home/settings/credentials');
              bloc.add(GetProfile());
            },
            label: "login".translate(),
            svgPath: "assets/svg/instagram.svg",
          ),
          const SizedBox(height: kPadding30),
        ],
      );
    }

    return Container();
  }

  Widget buildInstagram() {
    final bloc = context.read<ProfileBloc>();
    if (!bloc.profileCompletionStatus!.hasInstagramAccount) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding30),
      child: InstagramStatistics(
        instagramAccount: bloc.instagramAccount!,
      ),
    );
  }

  Widget buildComments() {
    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("comments".translate(), style: kTitle1Bold),
          const SizedBox(height: kPadding10),
          Text(
            "collaborate_for_comments".translate(),
            style: kBody.copyWith(color: kGrey300),
          ),
        ],
      ),
    );
  }

  Widget buildBrands() {
    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("brands".translate(), style: kTitle1Bold),
          const SizedBox(height: kPadding10),
          Text(
            "collab_with_brands".translate(),
            style: kBody.copyWith(color: kGrey300),
          ),
        ],
      ),
    );
  }

  /// ---

  @override
  bool get wantKeepAlive => true;
}
