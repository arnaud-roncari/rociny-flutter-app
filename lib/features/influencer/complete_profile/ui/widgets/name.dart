import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/influencer/complete_profile/bloc/complete_influencer_profile_informations/complete_influencer_profile_informations_bloc.dart';
import 'package:rociny/shared/decorations/textfield_decoration.dart';

class Name extends StatefulWidget {
  const Name({super.key});

  @override
  State<Name> createState() => _NameState();
}

class _NameState extends State<Name> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    CompleteInfluencerProfileInformationsBloc bloc = context.read<CompleteInfluencerProfileInformationsBloc>();
    controller.text = bloc.name ?? "";
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
              "influencer_name".translate(),
              style: kTitle1Bold,
            ),
            const SizedBox(height: kPadding10),
            Text(
              "enter_influencer_name".translate(),
              style: kBody.copyWith(color: kGrey300),
            ),
            const SizedBox(height: kPadding20),
            TextField(
              controller: controller,
              decoration: kTextFieldDecoration.copyWith(hintText: "name".translate()),
              style: kBody,
              onSubmitted: (value) {
                if (value.length < 3) {
                  Alert.showError(context, "minimum_3_characters");
                } else {
                  bloc.add(UpdateName(name: value));
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
