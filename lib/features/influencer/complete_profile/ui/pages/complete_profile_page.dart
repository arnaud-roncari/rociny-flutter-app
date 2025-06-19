import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/company/profile/ui/widgets/update_description_form.dart';
import 'package:rociny/features/company/profile/ui/widgets/update_geolocation_form.dart';
import 'package:rociny/features/company/profile/ui/widgets/update_social_networks_form.dart';
import 'package:rociny/features/influencer/complete_profile/bloc/complete_profile/complete_profile_bloc.dart';
import 'package:rociny/features/influencer/complete_profile/ui/widgets/update_profile_picture_form.dart';
import 'package:rociny/features/influencer/profile/ui/widgets/update_name_form.dart';
import 'package:rociny/features/influencer/profile/ui/widgets/update_portfolio_form.dart';
import 'package:rociny/features/influencer/profile/ui/widgets/update_target_audience_form.dart';
import 'package:rociny/features/influencer/profile/ui/widgets/update_themes_form.dart';
import 'package:rociny/shared/widgets/button.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

/// TODO mettre les form de profilepicture dans les profiles (inf / company)
class CompleteProfilPage extends StatefulWidget {
  const CompleteProfilPage({super.key});

  @override
  State<CompleteProfilPage> createState() => _CompleteProfilPageState();
}

class _CompleteProfilPageState extends State<CompleteProfilPage> {
  int index = 0;
  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
          child: BlocConsumer<CompleteProfileBloc, CompleteProfileState>(
        listener: (context, state) {
          if (state is GetProfileFailed ||
              state is UpdateProfilePictureFailed ||
              state is UpdatePortfolioFailed ||
              state is UpdateNameFailed ||
              state is UpdateDescriptionFailed ||
              state is UpdateGeolocationFailed ||
              state is UpdateThemesFailed ||
              state is UpdateTargetAudienceFailed ||
              state is UpdateSocialNetworkFailed ||
              state is AddSocialNetworkFailed ||
              state is DeleteSocialNetworkFailed) {
            Alert.showError(context, (state as dynamic).exception.message);
          }

          if (state is ProfileUpdated) {
            Alert.showSuccess(context, "changes_saved".translate());
          }
        },
        builder: (context, state) {
          if (state is GetProfileLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: kPrimary500,
              ),
            );
          }

          final bloc = context.read<CompleteProfileBloc>();
          final influencer = bloc.influencer;

          return Padding(
            padding: const EdgeInsets.all(kPadding20),
            child: Column(
              children: [
                Row(
                  children: [
                    SvgButton(
                      path: 'assets/svg/left_arrow.svg',
                      color: kBlack,
                      onPressed: () {
                        if (index != 0) {
                          setState(() {
                            index -= 1;
                          });
                          pageController.jumpToPage(index);
                        }
                      },
                    ),
                    const Spacer(),
                    Text("  ${"profile".translate()}", style: kTitle1Bold),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        context.go("/influencer/complete_profile/legal");
                      },
                      child: Text(
                        "ignore".translate(),
                        style: kBodyBold.copyWith(color: kGrey300),
                      ),
                    )
                  ],
                ),
                Center(
                  child: Text(
                    "${"step".translate()} ${index + 1} ${"out_of".translate()} 8",
                    style: kCaption.copyWith(color: kGrey300),
                  ),
                ),
                const SizedBox(height: kPadding30),
                Expanded(
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: pageController,
                    children: [
                      UpdateProfilePictureForm(
                        initialValue: influencer.profilePicture,
                        onUpdated: () {
                          bloc.add(UpdateProfilePicture());
                        },
                      ),
                      UpdatePortfolioForm(
                        initialValue: influencer.portfolio,
                        onAdded: () {
                          bloc.add(AddPicturesToPortfolio());
                        },
                        onRemoved: (pictureUrl) {
                          bloc.add(RemovePictureFromPortfolio(pictureUrl: pictureUrl));
                        },
                      ),
                      UpdateNameForm(
                        onUpdated: (name) {
                          bloc.add(UpdateName(name: name));
                        },
                        initialValue: influencer.name,
                      ),
                      UpdateDescriptionForm(
                        onUpdated: (description) {
                          bloc.add(UpdateDescription(description: description));
                        },
                        initialValue: influencer.description,
                      ),
                      UpdateGeolocationForm(
                        onUpdated: (geolocation) {
                          bloc.add(UpdateGeolocation(geolocation: geolocation));
                        },
                        initialValue: influencer.department,
                      ),
                      UpdateSocialNetworksForm(
                        initialValue: influencer.socialNetworks,
                        onUpdated: (id, url) {
                          bloc.add(UpdateSocialNetwork(id: id, url: url));
                        },
                        onAdded: (platform, url) {
                          bloc.add(AddSocialNetwork(platform: platform, url: url));
                        },
                        onDeleted: (id) {
                          bloc.add(DeleteSocialNetwork(id: id));
                        },
                      ),
                      UpdateThemesForm(
                        onUpdated: (themes) {
                          bloc.add(UpdateThemes(themes: themes));
                        },
                        initialValue: influencer.themes,
                      ),
                      UpdateTargetAudienceForm(
                        onUpdated: (targetAudience) {
                          bloc.add(UpdateTargetAudience(targetAudience: targetAudience));
                        },
                        initialValue: influencer.targetAudience,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: kPadding20),
                Button(
                  title: "next_step".translate(),
                  onPressed: () {
                    if (index != 7) {
                      setState(() {
                        index += 1;
                      });
                      pageController.jumpToPage(index);
                    } else {
                      context.go("/influencer/complete_profile/legal");
                    }
                  },
                ),
              ],
            ),
          );
        },
      )),
    );
  }
}
