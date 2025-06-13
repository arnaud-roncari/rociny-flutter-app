import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/company/complete_profile/bloc/complete_profile/complete_profile_bloc.dart';
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
    CompleteProfileBloc bloc = context.read<CompleteProfileBloc>();
    controller.text = bloc.name ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompleteProfileBloc, CompleteProfileState>(
      builder: (context, state) {
        CompleteProfileBloc bloc = context.read<CompleteProfileBloc>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "company_name".translate(),
              style: kTitle1Bold,
            ),
            const SizedBox(height: kPadding10),
            Text(
              "${"enter_company_name".translate()} ",
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
