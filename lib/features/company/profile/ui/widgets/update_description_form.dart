import 'package:flutter/material.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/shared/decorations/textfield_decoration.dart';
import 'package:rociny/shared/widgets/button.dart';

class UpdateDescriptionForm extends StatefulWidget {
  final String? initialValue;
  final void Function(String) onUpdated;
  const UpdateDescriptionForm({super.key, required this.onUpdated, required this.initialValue});

  @override
  State<UpdateDescriptionForm> createState() => _UpdateDescriptionFormState();
}

class _UpdateDescriptionFormState extends State<UpdateDescriptionForm> {
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
