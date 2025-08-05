import 'package:flutter/material.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/features/company/search/data/enums/product_placement_type.dart';

class ProductPlacementModal extends StatelessWidget {
  final ProductPlacementType type;
  final String description;
  const ProductPlacementModal({super.key, required this.type, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(kPadding20),
          topRight: Radius.circular(kPadding20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(kPadding20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(type.productPlacementTypeToString(), style: kTitle1Bold),
            const SizedBox(height: kPadding10),
            Text(
              description,
              style: kBody.copyWith(color: kGrey300),
            ),
            const SizedBox(height: kPadding30),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
