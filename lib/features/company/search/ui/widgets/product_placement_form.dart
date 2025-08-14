import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/company/search/bloc/preview/preview_bloc.dart';
import 'package:rociny/features/company/search/data/models/product_placement_model.dart';
import 'package:rociny/features/company/search/ui/widgets/product_placement_card.dart';
import 'package:rociny/shared/widgets/button.dart';
import 'package:rociny/shared/widgets/chip_button.dart';

class ProductPlacementForm extends StatefulWidget {
  const ProductPlacementForm({super.key});

  @override
  State<ProductPlacementForm> createState() => _ProductPlacementFormState();
}

class _ProductPlacementFormState extends State<ProductPlacementForm> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PreviewBloc>();
    return BlocConsumer<PreviewBloc, PreviewState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPadding20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Placements", style: kTitle1Bold),
              const SizedBox(height: kPadding10),
              Text(
                "Ajoutez des placements de produits que l'influenceur devra réaliser.",
                style: kBody.copyWith(color: kGrey300),
              ),
              const SizedBox(height: kPadding20),
              ChipButton(
                svgPath: "assets/svg/add.svg",
                onTap: () {
                  context.push("/company/home/preview/create/collaboration/create/product_placement");
                },
                label: "Créer un placement",
              ),
              const SizedBox(height: kPadding30),
              Builder(builder: (context) {
                List<Widget> children = [];
                for (ProductPlacement pp in bloc.collaboration.productPlacements) {
                  children.add(
                    Padding(
                      padding: const EdgeInsets.only(bottom: kPadding20),
                      child: ProductPlacementCard(
                        onRemoved: (productPlacement) {
                          bloc.add(RemoveProductPlacement(productPlacement: productPlacement));
                        },
                        productPlacement: pp,
                      ),
                    ),
                  );
                }
                return Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: children,
                    ),
                  ),
                );
              }),
              buildButton(),
              const SizedBox(height: kPadding20),
            ],
          ),
        );
      },
    );
  }

  Widget buildButton() {
    final bloc = context.read<PreviewBloc>();
    final productPlacements = bloc.collaboration.productPlacements;
    if (productPlacements.isEmpty) {
      return Button(
        // ignore: deprecated_member_use
        backgroundColor: kPrimary500.withOpacity(0.5),
        title: "continue".translate(),
        onPressed: () {
          bloc.add(UpdateStep(index: 3));
        },
      );
    }

    return Button(
      title: "continue".translate(),
      onPressed: () {
        context.read<PreviewBloc>().add(UpdateStep(index: 3));
      },
    );
  }
}
