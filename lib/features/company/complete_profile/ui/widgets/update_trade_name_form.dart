import 'package:flutter/material.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/core/utils/validators.dart';
import 'package:rociny/shared/decorations/textfield_decoration.dart';
import 'package:rociny/shared/widgets/button.dart';

class UpdateTradeNameForm extends StatefulWidget {
  final String? initialValue;
  final void Function(String) onUpdated;

  const UpdateTradeNameForm({
    super.key,
    this.initialValue,
    required this.onUpdated,
  });

  @override
  State<UpdateTradeNameForm> createState() => _UpdateVATStateForm();
}

class _UpdateVATStateForm extends State<UpdateTradeNameForm> {
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
            "Nom",
            style: kTitle1Bold,
          ),
          const SizedBox(height: kPadding10),
          Text(
            "Renseignez votre nom commercial.",
            style: kBody.copyWith(color: kGrey300),
          ),
          const SizedBox(height: kPadding20),
          TextFormField(
            controller: controller,
            decoration: kTextFieldDecoration.copyWith(hintText: "Nom"),
            validator: (value) => Validator.isNotEmpty(value),
            style: kBody,
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
