import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/core/utils/validators.dart';
import 'package:rociny/shared/decorations/textfield_decoration.dart';
import 'package:rociny/shared/widgets/button.dart';

class UpdateBillingAddressForm extends StatefulWidget {
  final String? city;
  final String? street;
  final String? postalCode;
  final void Function(String city, String street, String postalCode) onUpdated;

  const UpdateBillingAddressForm({
    super.key,
    this.city,
    this.street,
    this.postalCode,
    required this.onUpdated,
  });

  @override
  State<UpdateBillingAddressForm> createState() => _UpdateVATStateForm();
}

class _UpdateVATStateForm extends State<UpdateBillingAddressForm> {
  TextEditingController controllerCity = TextEditingController();
  TextEditingController controllerStreet = TextEditingController();
  TextEditingController controllerPostalCode = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controllerCity.text = widget.city ?? "";
    controllerStreet.text = widget.street ?? "";
    controllerPostalCode.text = widget.postalCode ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Adresse",
            style: kTitle1Bold,
          ),
          const SizedBox(height: kPadding10),
          Text(
            "Renseignez votre adresse de facturation.",
            style: kBody.copyWith(color: kGrey300),
          ),
          const SizedBox(height: kPadding20),
          TextFormField(
            controller: controllerCity,
            decoration: kTextFieldDecoration.copyWith(hintText: "Ville"),
            validator: (value) => Validator.isNotEmpty(value),
            style: kBody,
          ),
          const SizedBox(height: kPadding20),
          TextFormField(
            controller: controllerStreet,
            decoration: kTextFieldDecoration.copyWith(hintText: "Voie"),
            validator: (value) => Validator.isNotEmpty(value),
            style: kBody,
          ),
          const SizedBox(height: kPadding20),
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            controller: controllerPostalCode,
            decoration: kTextFieldDecoration.copyWith(hintText: "Code postal"),
            validator: (value) => Validator.isNotEmpty(value),
            style: kBody,
          ),
          const Spacer(),
          Button(
            title: "change".translate(),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                widget.onUpdated(
                  controllerCity.text,
                  controllerStreet.text,
                  controllerPostalCode.text,
                );
              }
            },
          )
        ],
      ),
    );
  }
}
