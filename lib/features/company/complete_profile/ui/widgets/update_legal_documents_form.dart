import 'package:flutter/widgets.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/influencer/complete_register/data/enums/legal_document_status.dart';
import 'package:rociny/features/influencer/complete_register/data/enums/legal_document_type.dart';
import 'package:rociny/shared/widgets/legal_document_card.dart';

class UpdateLegalDocumentsForm extends StatefulWidget {
  final Map<LegalDocumentType, LegalDocumentStatus> documents;
  final void Function(LegalDocumentType) onUpdated;

  const UpdateLegalDocumentsForm({
    super.key,
    required this.documents,
    required this.onUpdated,
  });

  @override
  State<UpdateLegalDocumentsForm> createState() => _UpdateLegalDocumentsStateForm();
}

class _UpdateLegalDocumentsStateForm extends State<UpdateLegalDocumentsForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "document".translate(),
          style: kTitle1Bold,
        ),
        const SizedBox(height: kPadding10),
        Text(
          "provide_documents".translate(),
          style: kBody.copyWith(color: kGrey300),
        ),
        const SizedBox(height: kPadding20),
        ...widget.documents.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: kPadding10),
            child: Padding(
              padding: const EdgeInsets.only(bottom: kPadding5),
              child: LegalDocumentCard(
                type: entry.key,
                status: entry.value,
                onTap: () {
                  widget.onUpdated(entry.key);
                },
              ),
            ),
          );
        }),
        const Spacer(),
      ],
    );
  }
}
