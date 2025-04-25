import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/influencer/complete_register/bloc/complete_profile_informations/complete_profile_informations_bloc.dart';
import 'package:rociny/features/influencer/complete_register/data/enums/platform_type.dart';
import 'package:rociny/features/influencer/complete_register/data/enums/social_network_sheet_type.dart';
import 'package:rociny/features/influencer/complete_register/data/models/social_network_model.dart';
import 'package:rociny/features/influencer/complete_register/ui/widgets/social_network_card.dart';
import 'package:rociny/features/influencer/complete_register/ui/widgets/supported_platforms_sheet.dart';
import 'package:rociny/shared/widgets/chip_button.dart';

class SocialNetworks extends StatefulWidget {
  const SocialNetworks({super.key});

  @override
  State<SocialNetworks> createState() => _SocialNetworksState();
}

class _SocialNetworksState extends State<SocialNetworks> {
  List<PlatformType> platforms = [
    PlatformType.linkedin,
    PlatformType.x,
    PlatformType.youtube,
    PlatformType.tiktok,
    PlatformType.twitch,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompleteProfileInformationsBloc, CompleteProfileInformationsState>(
      builder: (context, state) {
        CompleteProfileInformationsBloc bloc = context.read<CompleteProfileInformationsBloc>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "social_networks".translate(),
              style: kTitle1Bold,
            ),
            const SizedBox(height: kPadding10),
            Text(
              "add_your_social_networks".translate(),
              style: kBody.copyWith(color: kGrey300),
            ),
            const SizedBox(height: kPadding20),
            ChipButton(
              label: "add".translate(),
              svgPath: "assets/svg/add.svg",
              onTap: () async {
                addSocialNetwork();
              },
            ),
            const SizedBox(height: kPadding30),
            Column(
              children: List.generate(bloc.socialNetworks.length, (i) {
                SocialNetwork sn = bloc.socialNetworks[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: kPadding10),
                  child: SocialNetworkCard(
                    socialNetwork: sn,
                    onDelete: (toDelete) {
                      bloc.add(DeleteSocialNetwork(id: toDelete.id));
                    },
                    onUpdate: (sn) {
                      updateSocialNetwork(sn);
                    },
                  ),
                );
              }),
            ),
            const Spacer(),
          ],
        );
      },
    );
  }

  void addSocialNetwork() {
    CompleteProfileInformationsBloc bloc = context.read<CompleteProfileInformationsBloc>();

    showModalBottomSheet(
      context: context,
      backgroundColor: kWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(kRadius20)),
      ),
      builder: (context) {
        return BlocProvider.value(
          value: bloc,
          child: SupportedPlatformsSheet(
            platforms: platforms,
            onTap: (platform, url) {
              bloc.add(AddSocialNetwork(platform: platform, url: url));
              context.pop();
            },
          ),
        );
      },
    );
  }

  void updateSocialNetwork(SocialNetwork socialNetwork) {
    CompleteProfileInformationsBloc bloc = context.read<CompleteProfileInformationsBloc>();

    showModalBottomSheet(
      context: context,
      backgroundColor: kWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(kRadius20)),
      ),
      builder: (context) {
        return BlocProvider.value(
          value: bloc,
          child: SupportedPlatformsSheet(
            type: SocialNetworkSheetType.udpate,
            selectedSocialNetwork: socialNetwork,
            platforms: platforms,
            onTap: (platform, url) {
              bloc.add(UpdateSocialNetwork(id: socialNetwork.id, url: url));
              context.pop();
            },
          ),
        );
      },
    );
  }
}
