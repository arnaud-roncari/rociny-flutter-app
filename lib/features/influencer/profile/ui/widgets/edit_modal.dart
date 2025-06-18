import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/influencer/profile/bloc/profile_bloc.dart';
import 'package:rociny/features/influencer/settings/ui/widgets/navigation_button.dart';

class EditModal extends StatelessWidget {
  const EditModal({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ProfileBloc>();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(kPadding20),
          topRight: Radius.circular(kPadding20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(kPadding20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('profile'.translate(), style: kTitle1Bold),
            const SizedBox(height: kPadding10),
            Text(
              'complete_profile'.translate(),
              style: kBody.copyWith(color: kGrey300),
            ),
            const SizedBox(height: kPadding10),
            NavigationButton(
              label: "profile_picture".translate(),
              onPressed: () {
                bloc.add(UpdateProfilePicture());
                context.pop();
              },
            ),
            NavigationButton(
              label: "Porfolio",
              onPressed: () {
                context.pop();
                context.push("/influencer/home/profile/portfolio");
              },
            ),
            NavigationButton(
              label: "name".translate(),
              onPressed: () {
                context.pop();

                context.push("/influencer/home/profile/name");
              },
            ),
            NavigationButton(
              label: "geolocation".translate(),
              onPressed: () {
                context.pop();

                context.push("/influencer/home/profile/geolocation");
              },
            ),
            NavigationButton(
              label: "description".translate(),
              onPressed: () {
                context.pop();

                context.push("/influencer/home/profile/description");
              },
            ),
            NavigationButton(
              label: "social_networks".translate(),
              onPressed: () {
                context.pop();
                context.push("/influencer/home/profile/social_networks");
              },
            ),
            NavigationButton(
              label: "themes".translate(),
              onPressed: () {
                context.pop();
                context.push("/influencer/home/profile/themes");
              },
            ),
            NavigationButton(
              label: "target".translate(),
              onPressed: () {
                context.pop();
                context.push("/influencer/home/profile/target_audience");
              },
            ),
            NavigationButton(
              label: "Instagram",
              onPressed: () async {
                context.pop();
                await context.push('/influencer/home/settings/credentials');
                bloc.add(GetProfile());
              },
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
