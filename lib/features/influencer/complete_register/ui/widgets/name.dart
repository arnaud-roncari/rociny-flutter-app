import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/features/influencer/complete_register/bloc/complete_profile_informations/complete_profile_informations_bloc.dart';
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
    CompleteProfileInformationsBloc bloc = context.read<CompleteProfileInformationsBloc>();
    controller.text = bloc.name ?? "";
  }

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
              "Nom d'influenceur",
              style: kTitle1Bold,
            ),
            const SizedBox(height: kPadding10),
            Text(
              /// TODO translate
              "Renseignez votre nom d'influenceur. Vous pouvez utiliser un pseudonyme ou votre prénom et nom.",
              style: kBody.copyWith(color: kGrey300),
            ),
            const SizedBox(height: kPadding20),
            TextField(
              controller: controller,

              /// TODO translate
              decoration: kTextFieldDecoration.copyWith(hintText: "Nom"),
              style: kBody,
              onSubmitted: (value) {
                if (value.length < 3) {
                  /// TODO TRANSLATE
                  Alert.showError(context, "Minimum 3 charactères.");
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
