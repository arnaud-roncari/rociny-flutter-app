import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/validators.dart';
import 'package:rociny/features/company/search/bloc/preview/preview_bloc.dart';
import 'package:rociny/features/company/search/data/enums/product_placement_type.dart';
import 'package:rociny/features/company/search/data/models/product_placement_model.dart';
import 'package:rociny/features/company/search/ui/widgets/quantity_selector.dart';
import 'package:rociny/shared/decorations/textfield_decoration.dart';
import 'package:rociny/shared/widgets/button.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

/// TODO Ajouter juste prix
/// TODO translate
class CreateProductPlacementPage extends StatefulWidget {
  const CreateProductPlacementPage({super.key});

  @override
  State<CreateProductPlacementPage> createState() => _CreateProductPlacementPageState();
}

class _CreateProductPlacementPageState extends State<CreateProductPlacementPage> {
  ProductPlacementType selectedType = ProductPlacementType.post;
  int amount = 1;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// TODO scrollable
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kPadding20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgButton(
                      path: "assets/svg/left_arrow.svg",
                      color: kBlack,
                      onPressed: () {
                        context.pop();
                      },
                    ),
                    const Spacer(),
                    Text(
                      "Créer un placement",
                      style: kTitle1Bold,
                    ),
                    const Spacer(),
                    const SizedBox(width: kPadding20),
                  ],
                ),
                const SizedBox(height: kPadding15),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: kPadding15),
                        Text(
                          "Création de contenu",
                          style: kTitle1Bold,
                        ),
                        const SizedBox(height: kPadding10),
                        Text(
                          "Déterminez le type de création de contenu qui convient le mieux à vos objectifs.",
                          style: kBody.copyWith(color: kGrey300),
                        ),
                        const SizedBox(height: kPadding20),
                        Row(
                          children: [
                            buildTag(ProductPlacementType.post),
                            const SizedBox(width: kPadding5),
                            buildTag(ProductPlacementType.reel),
                            const SizedBox(width: kPadding5),
                            buildTag(ProductPlacementType.story),
                            const SizedBox(width: kPadding5),
                            buildTag(ProductPlacementType.giveaway),
                          ],
                        ),
                        const SizedBox(height: kPadding30),
                        Text(
                          "Nombre",
                          style: kTitle1Bold,
                        ),
                        const SizedBox(height: kPadding10),
                        Text(
                          "Combien de ${selectedType.productPlacementsTypeToString()} souhaitez-vous que l'influenceur crée ?",
                          style: kBody.copyWith(color: kGrey300),
                        ),
                        const SizedBox(height: kPadding20),
                        QuantitySelector(
                          onChanged: (newAmount) {
                            amount = newAmount;
                          },
                        ),
                        const SizedBox(height: kPadding30),
                        Text(
                          "Description",
                          style: kTitle1Bold,
                        ),
                        const SizedBox(height: kPadding10),
                        Text(
                          "Rédigez une description complète de vos attentes vis-à-vis de l'influenceur.",
                          style: kBody.copyWith(color: kGrey300),
                        ),
                        const SizedBox(height: kPadding20),
                        TextFormField(
                          decoration: kTextFieldDecoration.copyWith(hintText: "Description"),
                          controller: descriptionController,
                          validator: Validator.isNotEmpty,
                          style: kBody,
                          maxLength: 1000,
                        ),
                        const SizedBox(height: kPadding30),
                        Text(
                          "Prix",
                          style: kTitle1Bold,
                        ),
                        const SizedBox(height: kPadding10),
                        Text(
                          "Définissez le prix du placement.",
                          style: kBody.copyWith(color: kGrey300),
                        ),
                        const SizedBox(height: kPadding20),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: kTextFieldDecoration.copyWith(hintText: "Prix"),
                          controller: priceController,
                          validator: Validator.isNotEmpty,
                          style: kBody,
                        ),
                        const SizedBox(height: kPadding30),
                        Button(
                          title: "Créer",
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.read<PreviewBloc>().add(
                                    CreateProductPlacement(
                                      productPlacement: ProductPlacement.create(
                                        type: selectedType,
                                        quantity: amount,
                                        description: descriptionController.text,
                                        price: int.parse(priceController.text),
                                      ),
                                    ),
                                  );
                              context.pop();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTag(ProductPlacementType type) {
    bool isSelected = selectedType == type;

    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: isSelected ? kPrimary500 : kWhite,
        borderRadius: BorderRadius.circular(kRadius100),
        border: isSelected
            ? null
            : Border.all(
                color: kGrey100,
                width: 0.5,
              ),
      ),
      child: InkWell(
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        borderRadius: BorderRadius.circular(kRadius100),
        onTap: () {
          if (type == selectedType) {
            return;
          }

          setState(() {
            selectedType = type;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPadding15),
          child: Center(
            child: Text(
              type.productPlacementTypeToString(),
              style: isSelected ? kCaptionBold.copyWith(color: kWhite) : kCaption,
            ),
          ),
        ),
      ),
    );
  }
}
