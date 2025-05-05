import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/company/complete_register/bloc/complete_company_profile_informations/complete_company_profile_informations_bloc.dart';
import 'package:rociny/features/company/complete_register/ui/widgets/department.dart';
import 'package:rociny/features/company/complete_register/ui/widgets/description.dart';
import 'package:rociny/features/company/complete_register/ui/widgets/instagram.dart';
import 'package:rociny/features/company/complete_register/ui/widgets/name.dart';
import 'package:rociny/features/company/complete_register/ui/widgets/profile_picture.dart';
import 'package:rociny/features/company/complete_register/ui/widgets/social_networks.dart';
import 'package:rociny/shared/widgets/button.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

class CompleteCompanyProfileInformationsPage extends StatefulWidget {
  const CompleteCompanyProfileInformationsPage({super.key});

  @override
  State<CompleteCompanyProfileInformationsPage> createState() => _CompleteCompanyProfileInformationsPageState();
}

class _CompleteCompanyProfileInformationsPageState extends State<CompleteCompanyProfileInformationsPage> {
  int index = 0;
  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
          child: BlocConsumer<CompleteCompanyProfileInformationsBloc, CompleteCompanyProfileInformationsState>(
        listener: (context, state) {
          if (state is UpdateProfilePictureFailed ||
              state is UpdateNameFailed ||
              state is UpdateDescriptionFailed ||
              state is UpdateDepartmentFailed ||
              state is UpdateSocialNetworkFailed ||
              state is AddSocialNetworkFailed ||
              state is DeleteSocialNetworkFailed) {
            Alert.showError(context, (state as dynamic).exception.message);
          }

          if (state is UpdateProfilePictureSuccess ||
              state is UpdateNameSuccess ||
              state is UpdateDescriptionSuccess ||
              state is UpdateDepartmentSuccess ||
              state is UpdateSocialNetworkSuccess ||
              state is AddSocialNetworkSuccess ||
              state is DeleteSocialNetworkSuccess) {
            Alert.showSuccess(context, "changes_saved".translate());
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
                        context.go("/company/complete_register/legal");
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
                    "${"step".translate()} ${index + 1} ${"out_of".translate()} 6",
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
                      Name(),
                      Department(),
                      Description(),
                      SocialNetworks(),
                      Instagram(),
                    ],
                  ),
                ),
                Button(
                  title: "next_step".translate(),
                  onPressed: () {
                    if (index != 5) {
                      setState(() {
                        index += 1;
                      });
                      pageController.jumpToPage(index);
                    } else {
                      context.go("/company/complete_register/legal");
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
