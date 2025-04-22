import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/influencer/complete_register/bloc/complete_profile_informations/complete_profile_informations_bloc.dart';
import 'package:rociny/shared/widgets/chip_button.dart';

/// TODO ajouter : affiche les sn restant (faire une popup qui prend sn à créer, et un cb (type, url))
/// TODO pouvoir supprimer/modifier (croix au lieu de 3 dots)
/// TODO ouvrir url quand on clique dessus
class SocialNetworks extends StatefulWidget {
  const SocialNetworks({super.key});

  @override
  State<SocialNetworks> createState() => _SocialNetworksState();
}

class _SocialNetworksState extends State<SocialNetworks> {
  @override
  void initState() {
    super.initState();
    // CompleteProfileInformationsBloc bloc = context.read<CompleteProfileInformationsBloc>();
    // controller.text = bloc.department ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompleteProfileInformationsBloc, CompleteProfileInformationsState>(
      builder: (context, state) {
        // CompleteProfileInformationsBloc bloc = context.read<CompleteProfileInformationsBloc>();

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
                context.read<CompleteProfileInformationsBloc>().add(UpdatePortfolio());
              },
            ),
            const SizedBox(height: kPadding30),
            const Spacer(),
          ],
        );
      },
    );
  }
}
