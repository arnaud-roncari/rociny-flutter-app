import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/features/influencer/complete_register/bloc/complete_legal_informations/complete_legal_informations_bloc.dart';
import 'package:rociny/features/influencer/complete_register/data/enums/legal_document_type.dart';
import 'package:rociny/shared/widgets/legal_document_card.dart';

class LegalDocuments extends StatefulWidget {
  const LegalDocuments({super.key});

  @override
  State<LegalDocuments> createState() => _LegalDocumentsState();
}

class _LegalDocumentsState extends State<LegalDocuments> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompleteLegalInformationsBloc, CompleteLegalInformationsState>(
      builder: (context, state) {
        CompleteLegalInformationsBloc bloc = context.read<CompleteLegalInformationsBloc>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              /// TODO translate
              "Document",
              style: kTitle1Bold,
            ),
            const SizedBox(height: kPadding10),
            Text(
              /// TODO translate
              "Pour recevoir des collaborations, vous devez nous fournir les documents nécessaires.",
              style: kBody.copyWith(color: kGrey300),
            ),
            const SizedBox(height: kPadding20),
            LegalDocumentCard(
              type: LegalDocumentType.debug,
              status: bloc.debugStatus,
              onTap: () {
                bloc.add(UpdateDocument(type: LegalDocumentType.debug));
              },
            ),
            const Spacer(),
          ],
        );
      },
    );
  }
}
