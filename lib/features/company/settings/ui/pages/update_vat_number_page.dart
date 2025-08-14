import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/company/settings/bloc/settings_bloc.dart';
import 'package:rociny/features/influencer/complete_profile/ui/widgets/update_vat_form.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

class UpdateVATNumberPage extends StatelessWidget {
  const UpdateVATNumberPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SettingsBloc>();
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(kPadding20),
        child: BlocConsumer<SettingsBloc, SettingsState>(
          listener: (context, state) {
            if (state is UpdateVATNumberFailed) {
              Alert.showError(context, state.exception.message);
            }
            if (state is UpdateVATNumberSuccess) {
              context.pop();
            }
          },
          builder: (context, state) {
            if (state is UpdateVATNumberLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: kPrimary500,
                ),
              );
            }

            return Column(
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
                      "change".translate(),
                      style: kTitle1Bold,
                    ),
                    const SizedBox(width: kPadding20),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: kPadding30),
                Expanded(
                  child: UpdateVATForm(
                    onUpdated: (vatNumber) {
                      bloc.add(UpdateVATNumber(vatNumber: vatNumber));
                    },
                    initialValue: bloc.company.vatNumber,
                  ),
                ),
              ],
            );
          },
        ),
      )),
    );
  }
}
