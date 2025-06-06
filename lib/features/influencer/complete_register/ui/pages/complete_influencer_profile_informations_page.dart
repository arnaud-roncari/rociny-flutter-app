import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/influencer/complete_register/bloc/complete_influencer_profile_informations/complete_influencer_profile_informations_bloc.dart';
import 'package:rociny/features/influencer/complete_register/ui/widgets/department.dart';
import 'package:rociny/features/influencer/complete_register/ui/widgets/description.dart';
import 'package:rociny/features/influencer/complete_register/ui/widgets/instagram.dart';
import 'package:rociny/features/influencer/complete_register/ui/widgets/name.dart';
import 'package:rociny/features/influencer/complete_register/ui/widgets/portfolio.dart';
import 'package:rociny/features/influencer/complete_register/ui/widgets/profile_picture.dart';
import 'package:rociny/features/influencer/complete_register/ui/widgets/social_networks.dart';
import 'package:rociny/features/influencer/complete_register/ui/widgets/target_audience.dart';
import 'package:rociny/features/influencer/complete_register/ui/widgets/themes.dart';
import 'package:rociny/shared/widgets/button.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

/// faire gestion de document (en faire 1)(faire les requete pour changer le statut)
class CompleteInfluencerProfileInformationsPage extends StatefulWidget {
  const CompleteInfluencerProfileInformationsPage({super.key});

  @override
  State<CompleteInfluencerProfileInformationsPage> createState() => _CompleteInfluencerProfileInformationsPageState();
}

class _CompleteInfluencerProfileInformationsPageState extends State<CompleteInfluencerProfileInformationsPage> {
  int index = 0;
  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
          child: BlocConsumer<CompleteInfluencerProfileInformationsBloc, CompleteInfluencerProfileInformationsState>(
        listener: (context, state) {
          if (state is UpdateProfilePictureFailed ||
              state is UpdatePortfolioFailed ||
              state is UpdateNameFailed ||
              state is UpdateDescriptionFailed ||
              state is UpdateDepartmentFailed ||
              state is UpdateThemesFailed ||
              state is UpdateSocialNetworkFailed ||
              state is AddSocialNetworkFailed ||
              state is DeleteSocialNetworkFailed ||
              state is GetFacebookSessionFailed ||
              state is GetInstagramAccountsFailed ||
              state is CreateInstagramAccountFailed ||
              state is CreateInstagramAccountFailed ||
              state is UpdateTargetAudiencesFailed) {
            Alert.showError(context, (state as dynamic).exception.message);
          }

          if (state is UpdateProfilePictureSuccess ||
              state is UpdatePortfolioSuccess ||
              state is UpdateNameSuccess ||
              state is UpdateDescriptionSuccess ||
              state is UpdateDepartmentSuccess ||
              state is UpdateThemesSuccess ||
              state is UpdateSocialNetworkSuccess ||
              state is AddSocialNetworkSuccess ||
              state is DeleteSocialNetworkSuccess ||
              state is UpdateTargetAudiencesSuccess) {
            Alert.showSuccess(context, "changes_saved".translate());
          }

          if (state is CreateInstagramAccountSuccess) {
            Alert.showSuccess(context, "instagram_account_added_successfully".translate());
          }

          if (state is GetFacebookSessionSuccess) {
            CompleteInfluencerProfileInformationsBloc bloc = context.read<CompleteInfluencerProfileInformationsBloc>();
            if (bloc.hasFacebookSession) {
              bloc.add(GetInstagramAccounts());
            }
          }
        },
        builder: (context, state) {
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
                        context.go("/influencer/complete_register/legal");
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
                    "${"step".translate()} ${index + 1} ${"out_of".translate()} 9",
                    style: kCaption.copyWith(color: kGrey300),
                  ),
                ),
                const SizedBox(height: kPadding30),
                Expanded(
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: pageController,
                    children: const [
                      ProfilePicture(),
                      Portfolio(),
                      Name(),
                      Description(),
                      Department(),
                      SocialNetworks(),
                      Themes(),
                      TargetAudience(),
                      Instagram(),
                    ],
                  ),
                ),
                Button(
                  title: "next_step".translate(),
                  onPressed: () {
                    if (index != 8) {
                      setState(() {
                        index += 1;
                      });
                      pageController.jumpToPage(index);
                    } else {
                      context.go("influencer/complete_register/legal");
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
