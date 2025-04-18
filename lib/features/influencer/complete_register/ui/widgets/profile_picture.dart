import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/features/influencer/complete_register/bloc/complete_profile_informations/complete_profile_informations_bloc.dart';
import 'package:rociny/shared/widgets/chip_button.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({super.key});

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompleteProfileInformationsBloc, CompleteProfileInformationsState>(
      builder: (context, state) {
        CompleteProfileInformationsBloc bloc = context.read<CompleteProfileInformationsBloc>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              /// TODO translate
              "Photo de profil",
              style: kTitle1Bold,
            ),
            const SizedBox(height: kPadding10),
            Text(
              /// TODO translate
              "Publiez votre photo de profil.",
              style: kBody.copyWith(color: kGrey300),
            ),
            const SizedBox(height: kPadding20),
            ChipButton(
              /// TODO TRANSLATE
              label: "Photo de profil",
              svgPath: "assets/svg/upload.svg",
              onTap: () async {
                context.read<CompleteProfileInformationsBloc>().add(UpdateProfilePicture());
              },
            ),
            const SizedBox(height: kPadding30),
            if (bloc.profilePicture != null)
              LayoutBuilder(builder: (context, constraints) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kRadius10),
                  ),
                  width: constraints.maxWidth,
                  height: constraints.maxWidth,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(kRadius10),
                    child: Image(
                      image: NetworkImage(
                        "$kEndpoint/influencer/get-profile-picture?dummy=${DateTime.now().millisecondsSinceEpoch}",
                        headers: {
                          'Authorization': 'Bearer $kJwt',
                        },
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }),
            const Spacer(),
          ],
        );
      },
    );
  }
}
