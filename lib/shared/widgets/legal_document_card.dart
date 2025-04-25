import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/features/influencer/complete_register/data/enums/legal_document_status.dart' as lds;
import 'package:rociny/features/influencer/complete_register/data/enums/legal_document_type.dart';

class LegalDocumentCard extends StatelessWidget {
  final void Function() onTap;
  final lds.LegalDocumentStatus status;
  final LegalDocumentType type;
  const LegalDocumentCard({super.key, required this.onTap, required this.status, required this.type});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Nom du document",
                style: kBody,
              ),
              const Spacer(),
              SvgPicture.asset(
                "assets/svg/right_arrow.svg",
                width: 20,
                height: 20,
              ),
            ],
          ),
          const SizedBox(height: kPadding5),
          Text(
            lds.getDisplayedName(status),
            style: kCaption.copyWith(color: getColor()),
          ),
          const SizedBox(height: kPadding10),
          Container(
            height: 1,
            width: double.infinity,
            color: kGrey100,
          )
        ],
      ),
    );
  }

  Color getColor() {
    switch (status) {
      case lds.LegalDocumentStatus.missing:
        return kRed500;
      case lds.LegalDocumentStatus.pending:
        return kBlue500;
      case lds.LegalDocumentStatus.validated:
        return kGreen500;
      case lds.LegalDocumentStatus.refused:
        return kRed500;
    }
  }
}
