import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/company/profile/bloc/profile_bloc.dart';
import 'package:rociny/features/company/profile/data/models/profile_completion_status.dart';
import 'package:rociny/features/company/profile/ui/widgets/company_profile.dart';
import 'package:rociny/features/company/profile/ui/widgets/edit_modal.dart';
import 'package:rociny/features/company/profile/ui/widgets/warning_modal.dart';
import 'package:rociny/shared/widgets/chip_button.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: kPadding20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPadding20),
              child: Row(
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
                        context.push("/company/home/settings");
                      },
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: kPadding15),
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
                        const SizedBox(height: kPadding15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: kPadding20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildAddProfilePicture(),
                              buildAddName(),
                              buildAddGeolocation(),
                              buildAddDescription(),
                              buildAddSocialNetworks(),
                              buildAddInstagram(),
                            ],
                          ),
                        ),
                        CompanyProfile(
                          company: bloc.company,
                          instagramAccount: bloc.instagramAccount,
                          reviewSummaries: bloc.reviewSummaries,
                          collaboratedInfluencers: bloc.collaboratedInfluencers,
                        ),
                        const SizedBox(height: kPadding20),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }

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
            label: "profile_photo".translate(),
            svgPath: "assets/svg/cloud_upload.svg",
          ),
          const SizedBox(height: kPadding30),
        ],
      );
    }

    return Container();
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
            "set_company_name".translate(),
            style: kBody.copyWith(color: kGrey300),
          ),
          const SizedBox(height: kPadding20),
          ChipButton(
            onTap: () {
              context.push("/company/home/profile/name");
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
              context.push("/company/home/profile/geolocation");
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
              context.push("/company/home/profile/description");
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
              context.push("/company/home/profile/social_networks");
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
              await context.push('/company/home/settings/credentials');
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

  @override
  bool get wantKeepAlive => true;
}
