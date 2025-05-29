import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/influencer/complete_register/data/enums/legal_document_type.dart';
import 'package:rociny/features/company/settings/bloc/settings_bloc.dart';
import 'package:rociny/shared/widgets/legal_document_card.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

class LegalDocumentsPage extends StatefulWidget {
  const LegalDocumentsPage({super.key});

  @override
  State<LegalDocumentsPage> createState() => _LegalDocumentsPageState();
}

class _LegalDocumentsPageState extends State<LegalDocumentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(kPadding20),
        child: BlocConsumer<SettingsBloc, SettingsState>(
          listener: (context, state) {
            if (state is UpdateLegalDocumentFailed) {
              Alert.showError(context, state.exception.message);
            }
          },
          builder: (context, state) {
            final bloc = context.read<SettingsBloc>();

            if (state is GetLegalDocumentsStatusLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: kPrimary500,
                ),
              );
            }

            return Column(
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
                      "documents".translate(),
                      style: kTitle1Bold,
                    ),
                    const Spacer(),
                    const SizedBox(width: kPadding20),
                  ],
                ),
                const SizedBox(height: kPadding30),
                Text(
                  "documents".translate(),
                  style: kTitle1Bold,
                ),
                const SizedBox(height: kPadding10),
                Text(
                  "provide_documents",
                  style: kBody.copyWith(color: kGrey300),
                ),
                const SizedBox(height: kPadding20),
                LegalDocumentCard(
                  onTap: () {
                    bloc.add(UpdateLegalDocument(type: LegalDocumentType.debug));
                  },
                  status: bloc.debugStatus,
                  type: LegalDocumentType.debug,
                ),
              ],
            );
          },
        ),
      )),
    );
  }
}
