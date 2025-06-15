import 'package:flutter/material.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/core/utils/validators.dart';
import 'package:rociny/shared/decorations/textfield_decoration.dart';
import 'package:rociny/shared/widgets/button.dart';

class UpdateNameForm extends StatefulWidget {
  final String? initialValue;
  final void Function(String) onUpdated;
  const UpdateNameForm({super.key, required this.onUpdated, required this.initialValue});

  @override
  State<UpdateNameForm> createState() => _UpdateNameFormState();
}

class _UpdateNameFormState extends State<UpdateNameForm> {
  TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller.text = widget.initialValue ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
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
          TextFormField(
            controller: controller,
            validator: Validator.name,
            decoration: kTextFieldDecoration.copyWith(hintText: "name".translate()),
            style: kBody,
          ),
          const SizedBox(height: kPadding30),
          const Spacer(),
          Button(
            title: "Modifier",
            onPressed: () {
              if (formKey.currentState!.validate()) {
                widget.onUpdated(controller.text);
              }
            },
          )
        ],
      ),
    );
  }
}
