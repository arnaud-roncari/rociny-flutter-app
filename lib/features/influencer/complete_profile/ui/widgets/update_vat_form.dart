import 'package:flutter/material.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/core/utils/validators.dart';
import 'package:rociny/shared/decorations/textfield_decoration.dart';
import 'package:rociny/shared/widgets/button.dart';

class UpdateVATForm extends StatefulWidget {
  final String? initialValue;
  final void Function(String) onUpdated;

  const UpdateVATForm({
    super.key,
    this.initialValue,
    required this.onUpdated,
  });

  @override
  State<UpdateVATForm> createState() => _UpdateVATStateForm();
}

class _UpdateVATStateForm extends State<UpdateVATForm> {
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
            "Facture",
            style: kTitle1Bold,
          ),
          const SizedBox(height: kPadding10),
          Text(
            "Veuillez indiquer votre numéro de TVA si applicable.",
            style: kBody.copyWith(color: kGrey300),
          ),
          const SizedBox(height: kPadding20),
          TextFormField(
            controller: controller,
            decoration: kTextFieldDecoration.copyWith(hintText: "Numéro de TVA"),
            validator: (value) => Validator.isMinimumLength(value, 13),
            style: kBody,
            maxLength: 13,
          ),
          const Spacer(),
          Button(
            title: "change".translate(),
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
