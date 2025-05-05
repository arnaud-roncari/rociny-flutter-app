import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/influencer/complete_register/bloc/complete_influencer_profile_informations/complete_influencer_profile_informations_bloc.dart';
import 'package:rociny/shared/decorations/textfield_decoration.dart';

class Description extends StatefulWidget {
  const Description({super.key});

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    CompleteInfluencerProfileInformationsBloc bloc = context.read<CompleteInfluencerProfileInformationsBloc>();
    controller.text = bloc.description ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompleteInfluencerProfileInformationsBloc, CompleteInfluencerProfileInformationsState>(
      builder: (context, state) {
        CompleteInfluencerProfileInformationsBloc bloc = context.read<CompleteInfluencerProfileInformationsBloc>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "description".translate(),
              style: kTitle1Bold,
            ),
            const SizedBox(height: kPadding10),
            Text(
              "describe_yourself".translate(),
              style: kBody.copyWith(color: kGrey300),
            ),
            const SizedBox(height: kPadding20),
            TextField(
              controller: controller,
              maxLength: 1000,
              decoration: kTextFieldDecoration.copyWith(
                hintText: "description".translate(),
              ),
              style: kBody,
              onSubmitted: (value) {
                if (value.length < 10) {
                  Alert.showError(context, "minimum_10_characters".translate());
                } else {
                  bloc.add(UpdateDescription(description: value));
                }
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
