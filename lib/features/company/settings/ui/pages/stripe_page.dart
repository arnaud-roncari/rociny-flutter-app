import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/company/settings/bloc/settings_bloc.dart';
import 'package:rociny/shared/widgets/chip_button.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

class StripePage extends StatefulWidget {
  const StripePage({super.key});

  @override
  State<StripePage> createState() => _StripePageState();
}

class _StripePageState extends State<StripePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(kPadding20),
        child: BlocConsumer<SettingsBloc, SettingsState>(
          listener: (context, state) async {},
          builder: (context, state) {
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
                      "Stripe",
                      style: kTitle1Bold,
                    ),
                    const Spacer(),
                    const SizedBox(width: kPadding20),
                  ],
                ),
                const SizedBox(height: kPadding30),
                Text(
                  "Stripe",
                  style: kTitle1Bold,
                ),
                const SizedBox(height: kPadding10),
                Text(
                  getText(),
                  style: kBody.copyWith(color: kGrey300),
                ),
                const SizedBox(height: kPadding20),
                ChipButton(
                  label: getChipText(),
                  onTap: () async {
                    SettingsBloc bloc = context.read<SettingsBloc>();
                    if (state is CreateSetupIntentLoading) {
                      return;
                    }

                    bloc.add(CreateSetupIntent());
                  },
                ),
                const Spacer(),
              ],
            );
          },
        ),
      )),
    );
  }

  String getText() {
    return "rociny_stripe_payment".translate();
  }

  String getChipText() {
    return "Ajouter un moyen de paiement";
  }
}
