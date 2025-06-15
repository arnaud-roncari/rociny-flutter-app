import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/company/complete_profile/bloc/complete_profile/complete_profile_bloc.dart';
import 'package:rociny/features/company/complete_profile/ui/widgets/update_profile_picture_form.dart';
import 'package:rociny/features/company/profile/data/models/company.dart';
import 'package:rociny/features/company/profile/ui/widgets/update_description_form.dart';
import 'package:rociny/features/company/profile/ui/widgets/update_geolocation_form.dart';
import 'package:rociny/features/company/profile/ui/widgets/update_name_form.dart';
import 'package:rociny/features/company/profile/ui/widgets/update_social_networks_form.dart';
import 'package:rociny/shared/widgets/button.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  int index = 0;
  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
          child: BlocConsumer<CompleteProfileBloc, CompleteProfileState>(
        listener: (context, state) {
          if (state is UpdateProfilePictureFailed ||
              state is UpdateNameFailed ||
              state is GetProfileFailed ||
              state is UpdateDescriptionFailed ||
              state is UpdateGeolocationFailed ||
              state is UpdateSocialNetworkFailed ||
              state is AddSocialNetworkFailed ||
              state is UpdateDocumentFailed ||
              state is CreateSetupIntentFailed ||
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
          final Company company = bloc.company;
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
                        context.go("/company/complete_profile/legal");
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
                    "${"step".translate()} ${index + 1} ${"out_of".translate()} 5",
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
                        onUpdated: () {
                          bloc.add(UpdateProfilePicture());
                        },
                        initialValue: company.profilePicture,
                        full: false,
                      ),
                      UpdateNameForm(
                        onUpdated: (name) {
                          bloc.add(UpdateName(name: name));
                        },
                        initialValue: company.name,
                      ),
                      UpdateGeolocationForm(
                        onUpdated: (department) {
                          bloc.add(UpdateGeolocation(geolocation: department));
                        },
                        initialValue: company.department,
                      ),
                      UpdateDescriptionForm(
                        onUpdated: (description) {
                          bloc.add(UpdateDescription(description: description));
                        },
                        initialValue: company.description,
                      ),
                      UpdateSocialNetworksForm(
                        initialValue: company.socialNetworks,
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
                    ],
                  ),
                ),
                const SizedBox(height: kPadding20),
                Button(
                  backgroundColor: kPrimary700,
                  title: "next_step".translate(),
                  onPressed: () {
                    if (index != 4) {
                      setState(() {
                        index += 1;
                      });
                      pageController.jumpToPage(index);
                    } else {
                      context.go("/company/complete_profile/legal_illustration");
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
