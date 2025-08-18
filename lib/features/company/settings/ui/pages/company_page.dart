import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/company/settings/bloc/settings_bloc.dart';
import 'package:rociny/features/influencer/settings/ui/widgets/company_section_button.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

class CompanyPage extends StatefulWidget {
  const CompanyPage({super.key});

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(kPadding20),
        child: BlocConsumer<SettingsBloc, SettingsState>(
          listener: (context, state) {
            if (state is GetCompanySectionsStatusFailed) {
              Alert.showError(context, state.exception.message);
              context.pop();
            }
          },
          builder: (context, state) {
            final bloc = context.read<SettingsBloc>();

            if (state is GetCompanySectionsStatusLoading) {
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
                      "my_company".translate(),
                      style: kTitle1Bold,
                    ),
                    const Spacer(),
                    const SizedBox(width: kPadding20),
                  ],
                ),
                const SizedBox(height: kPadding30),
                Text(
                  "legal_information".translate(),
                  style: kTitle1Bold,
                ),
                const SizedBox(height: kPadding10),
                Text(
                  "legal_information_description".translate(),
                  style: kBody.copyWith(color: kGrey300),
                ),
                const SizedBox(height: kPadding20),
                CompanySectionButton(
                  onTap: () {
                    bloc.add(GetLegalDocumentsStatus());
                    context.push("/company/home/settings/company/legal-documents");
                  },
                  isCompleted: bloc.hasCompletedLegalDocuments,
                  name: "document".translate(),
                ),
                const SizedBox(height: kPadding15),
                CompanySectionButton(
                  onTap: () {
                    context.push("/company/home/settings/company/stripe");
                  },
                  isCompleted: bloc.hasCompletedStripe,
                  name: "Stripe",
                ),
                const SizedBox(height: kPadding15),
                CompanySectionButton(
                  onTap: () {
                    context.push("/company/home/settings/company/trade-name");
                  },
                  isCompleted: bloc.company.tradeName != null,
                  name: "Nom",
                ),
                const SizedBox(height: kPadding15),
                CompanySectionButton(
                  onTap: () {
                    context.push("/company/home/settings/company/billing-address");
                  },
                  isCompleted:
                      bloc.company.postalCode != null && bloc.company.street != null && bloc.company.city != null,
                  name: "Adresse de facturation",
                ),
                const SizedBox(height: kPadding15),
                CompanySectionButton(
                  onTap: () {
                    context.push("/company/home/settings/company/vat");
                  },
                  isCompleted: bloc.company.vatNumber == null ? null : true,
                  name: "Numéro de TVA",
                ),
              ],
            );
          },
        ),
      )),
    );
  }
}
