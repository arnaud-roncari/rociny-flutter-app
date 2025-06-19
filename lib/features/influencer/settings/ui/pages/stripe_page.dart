import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/features/influencer/complete_profile/ui/widgets/stripe_form.dart';
import 'package:rociny/features/influencer/settings/bloc/settings_bloc.dart';
import 'package:rociny/shared/widgets/stripe_modal.dart';
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
          listener: (context, state) async {
            final bloc = context.read<SettingsBloc>();

            if (state is GetStripeCompletionStatusFailed || state is UpdateStripeFailed) {
              Alert.showError(context, (state as dynamic).exception.message);
            }

            if (state is StripeUrlFetched) {
              String url = state.url;
              await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                enableDrag: false,
                backgroundColor: kWhite,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                builder: (context) {
                  return StripeModal(url: url);
                },
              );

              bloc.add(GetStripeCompletionStatus());
            }
          },
          builder: (context, state) {
            final bloc = context.read<SettingsBloc>();

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
                Expanded(
                  child: StripeForm(
                    isStripeCompleted: bloc.hasCompletedStripe,
                    onPressed: (isStripeCompleted) {
                      if (isStripeCompleted) {
                        bloc.add(GetStripeAccount());
                      } else {
                        bloc.add(CreateStripeAccount());
                      }
                    },
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
