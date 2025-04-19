import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/features/influencer/complete_register/bloc/complete_profile_informations/complete_profile_informations_bloc.dart';
import 'package:rociny/features/influencer/complete_register/ui/widgets/department.dart';
import 'package:rociny/features/influencer/complete_register/ui/widgets/description.dart';
import 'package:rociny/features/influencer/complete_register/ui/widgets/name.dart';
import 'package:rociny/features/influencer/complete_register/ui/widgets/portfolio.dart';
import 'package:rociny/features/influencer/complete_register/ui/widgets/profile_picture.dart';
import 'package:rociny/shared/widgets/button.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

/// TODO créer un bloc
/// utilier file picker (pour un et plusieurs fichier) (autoriser que png, jpg ...)
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
          child: BlocConsumer<CompleteProfileInformationsBloc, CompleteProfileInformationsState>(
        listener: (context, state) {
          if (state is UpdateProfilePictureFailed ||
              state is UpdatePortfolioFailed ||
              state is UpdateNameFailed ||
              state is UpdateDescriptionFailed ||
              state is UpdateDepartmentFailed ||
              state is UpdateThemesFailed ||
              state is UpdateTargetAudienceFailed) {
            Alert.showError(context, (state as dynamic).exception.message);
          }

          if (state is UpdateProfilePictureSuccess ||
              state is UpdatePortfolioSuccess ||
              state is UpdateNameSuccess ||
              state is UpdateDescriptionSuccess ||
              state is UpdateDepartmentSuccess ||
              state is UpdateThemesSuccess ||
              state is UpdateTargetAudienceSuccess) {
            Alert.showSuccess(context, "Modifications sauvegardées.");
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

                    /// TODO translate
                    Text("  Profil", style: kTitle1Bold),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        context.go("influencer/complete_profile/legal");
                      },
                      child: Text(
                        /// TODO translate

                        "Ignorer",
                        style: kBodyBold.copyWith(color: kGrey300),
                      ),
                    )
                  ],
                ),
                Center(
                  child: Text(
                    /// TODO transalate
                    "Étape ${index + 1} sur 9",
                    style: kCaption.copyWith(color: kGrey300),
                  ),
                ),
                const SizedBox(height: kPadding30),
                Expanded(
                  child: PageView(
                    controller: pageController,
                    children: [
                      const ProfilePicture(),
                      const Portfolio(),
                      const Name(),
                      const Description(),
                      const Department(),
                      Container(),
                      Container(),
                      Container(),
                      Container(),
                    ],
                  ),
                ),
                Button(
                  /// TODO translate
                  title: "Suivant",
                  onPressed: () {
                    if (index != 8) {
                      setState(() {
                        index += 1;
                      });
                      pageController.jumpToPage(index);
                    } else {
                      /// TODO naviguer sur legal informations
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
