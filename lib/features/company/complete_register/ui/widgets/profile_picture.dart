import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/company/complete_register/bloc/complete_company_profile_informations/complete_company_profile_informations_bloc.dart';
import 'package:rociny/shared/widgets/chip_button.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({super.key});

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompleteCompanyProfileInformationsBloc, CompleteCompanyProfileInformationsState>(
      builder: (context, state) {
        CompleteCompanyProfileInformationsBloc bloc = context.read<CompleteCompanyProfileInformationsBloc>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "profile_picture".translate(),
              style: kTitle1Bold,
            ),
            const SizedBox(height: kPadding10),
            Text(
              "publish_your_profile_picture".translate(),
              style: kBody.copyWith(color: kGrey300),
            ),
            const SizedBox(height: kPadding20),
            ChipButton(
              label: "profile_picture".translate(),
              svgPath: "assets/svg/upload.svg",
              onTap: () async {
                context.read<CompleteCompanyProfileInformationsBloc>().add(UpdateProfilePicture());
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
                        "$kEndpoint/company/get-profile-picture?dummy=${DateTime.now().millisecondsSinceEpoch}",
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
