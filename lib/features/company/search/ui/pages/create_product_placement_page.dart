import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/core/utils/validators.dart';
import 'package:rociny/features/company/search/bloc/preview/preview_bloc.dart';
import 'package:rociny/features/company/search/data/enums/product_placement_type.dart';
import 'package:rociny/features/company/search/data/models/product_placement_model.dart';
import 'package:rociny/features/company/search/ui/widgets/quantity_selector.dart';
import 'package:rociny/shared/decorations/textfield_decoration.dart';
import 'package:rociny/shared/widgets/button.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

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

  @override
  void initState() {
    super.initState();
    context.read<PreviewBloc>().add(GetProductPlacementPrice(type: ProductPlacementType.post));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: BlocConsumer<PreviewBloc, PreviewState>(
          listener: (context, state) {
            final bloc = context.read<PreviewBloc>();
            if (state is GetProductPlacementPriceSuccess) {
              setState(() {
                priceController.text = (bloc.suggestedPrice! * amount).toString();
              });
            }
          },
          builder: (context, state) {
            return Padding(
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
                          "create_placement".translate(),
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
                              "content_creation".translate(),
                              style: kTitle1Bold,
                            ),
                            const SizedBox(height: kPadding10),
                            Text(
                              "choose_content_type".translate(),
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
                              "number".translate(),
                              style: kTitle1Bold,
                            ),
                            const SizedBox(height: kPadding10),
                            Text(
                              "${"number_instruction_part1".translate()} ${selectedType.productPlacementsTypeToString()} ${"number_instruction_part2".translate()}",
                              style: kBody.copyWith(color: kGrey300),
                            ),
                            const SizedBox(height: kPadding20),
                            QuantitySelector(
                              onChanged: (newAmount) {
                                final bloc = context.read<PreviewBloc>();
                                setState(() {
                                  amount = newAmount;
                                  if (bloc.suggestedPrice != null) {
                                    priceController.text = (bloc.suggestedPrice! * amount).toString();
                                  }
                                });
                              },
                            ),
                            const SizedBox(height: kPadding30),
                            Text(
                              "description".translate(),
                              style: kTitle1Bold,
                            ),
                            const SizedBox(height: kPadding10),
                            Text(
                              "description_instruction".translate(),
                              style: kBody.copyWith(color: kGrey300),
                            ),
                            const SizedBox(height: kPadding20),
                            TextFormField(
                              decoration: kTextFieldDecoration.copyWith(hintText: "description".translate()),
                              controller: descriptionController,
                              validator: Validator.isNotEmpty,
                              style: kBody,
                              maxLength: 1000,
                            ),
                            const SizedBox(height: kPadding30),
                            Text(
                              "price".translate(),
                              style: kTitle1Bold,
                            ),
                            const SizedBox(height: kPadding10),
                            Text(
                              "set_price_instruction".translate(),
                              style: kBody.copyWith(color: kGrey300),
                            ),
                            const SizedBox(height: kPadding20),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: kTextFieldDecoration.copyWith(hintText: "price".translate()),
                              controller: priceController,
                              validator: Validator.isNotEmpty,
                              style: kBody,
                            ),
                            const SizedBox(height: kPadding5),
                            getSuggestedPrice(state),
                            const SizedBox(height: kPadding30),
                            Button(
                              title: "create".translate(),
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
            );
          },
        ),
      ),
    );
  }

  Widget getSuggestedPrice(PreviewState state) {
    final bloc = context.read<PreviewBloc>();

    if (state is GetProductPlacementPriceLoading || bloc.suggestedPrice == null) {
      return SizedBox(
        height: 11,
        width: 11,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: kPrimary500,
        ),
      );
    }
    return Row(
      children: [
        Text(
          "${"recommended_price_prefix".translate()} ",
          style: kCaption.copyWith(color: kGrey300),
        ),
        Text(
          "${bloc.suggestedPrice! * amount} ${"recommended_price_suffix".translate()}",
          style: kCaptionBold.copyWith(color: kPrimary500),
        ),
      ],
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

          context.read<PreviewBloc>().add(GetProductPlacementPrice(type: selectedType));
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
