import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/features/company/search/data/models/product_placement_model.dart';
import 'package:rociny/shared/decorations/container_shadow_decoration.dart';

/// TODO faire modal qui montre descriotion
class ProductPlacementCard extends StatelessWidget {
  final void Function(ProductPlacement)? onRemoved;
  final ProductPlacement productPlacement;

  const ProductPlacementCard({super.key, this.onRemoved, required this.productPlacement});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: kContainerShadow,
      child: Padding(
        padding: const EdgeInsets.all(kPadding20),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${productPlacement.quantity} ${productPlacement.type.productPlacementTypeToString()}",
                  style: kCaption,
                ),
                const SizedBox(height: kPadding5),
                Text(
                  "${productPlacement.price} €",
                  style: kHeadline5Bold,
                ),
              ],
            ),
            const Spacer(),
            if (onRemoved != null)
              PopupMenuButton<String>(
                tooltip: "",
                padding: EdgeInsets.zero,
                menuPadding: EdgeInsets.zero,
                color: kWhite,
                child: SvgPicture.asset(
                  "assets/svg/menu_vertical.svg",
                  width: 20,
                  height: 20,
                ),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: "delete",
                      child: Text(
                        "Supprimer",
                        style: kBody,
                      ),
                      onTap: () {
                        onRemoved!(productPlacement);
                      },
                    ),
                  ];
                },
              ),
          ],
        ),
      ),
    );
  }
}
