import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/features/company/profile/bloc/profile_bloc.dart';
import 'package:rociny/features/influencer/settings/ui/widgets/settings_button.dart';

/// TODO translate
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
            Text('Profil', style: kTitle1Bold),
            const SizedBox(height: kPadding10),
            Text(
              'Complétez votre profil.',
              style: kBody.copyWith(color: kGrey300),
            ),
            const SizedBox(height: kPadding10),
            SettingsButton(
              label: "Photo de profil",
              onPressed: () {
                bloc.add(UpdateProfilePicture());
                context.pop();
              },
            ),
            SettingsButton(
              label: "Nom",
              onPressed: () {
                context.pop();

                context.push("/company/home/profile/name");
              },
            ),
            SettingsButton(
              label: "Géolocalisation",
              onPressed: () {
                context.pop();

                context.push("/company/home/profile/geolocation");
              },
            ),
            SettingsButton(
              label: "Description",
              onPressed: () {
                context.pop();

                context.push("/company/home/profile/description");
              },
            ),
            SettingsButton(
              label: "Réseaux sociaux",
              onPressed: () {
                context.pop();
                context.push("/company/home/profile/social_networks");
              },
            ),
            SettingsButton(
              label: "Instagram",
              onPressed: () async {
                context.pop();
                await context.push('/company/settings/credentials');
                bloc.add(GetProfile());
              },
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  /// TODO réduire la taille de la barre de navigation
}
