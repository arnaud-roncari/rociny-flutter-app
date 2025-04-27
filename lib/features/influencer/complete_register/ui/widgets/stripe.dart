import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/influencer/complete_register/bloc/complete_legal_informations/complete_legal_informations_bloc.dart';
import 'package:rociny/shared/widgets/chip_button.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Stripe extends StatefulWidget {
  const Stripe({super.key});

  @override
  State<Stripe> createState() => _StripeState();
}

class _StripeState extends State<Stripe> {
  late WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CompleteLegalInformationsBloc, CompleteLegalInformationsState>(
      listener: (context, state) async {
        CompleteLegalInformationsBloc bloc = context.read<CompleteLegalInformationsBloc>();

        if (state is GetStripeAccountLinkSuccess) {
          var bool = await context.push("/influencer/complete_register/complete_stripe", extra: bloc.stripeAccountUrl!);
          if (bool != null && bool == true) {
            bloc.add(SetStripeAccountStatus());
            // ignore: use_build_context_synchronously
            Alert.showSuccess(context, "Modifications sauvegardées.");
          } else {
            // ignore: use_build_context_synchronously
            Alert.showError(context, "Votre compte Stripe est incomplet.");
          }
        }
      },
      builder: (context, state) {
        CompleteLegalInformationsBloc bloc = context.read<CompleteLegalInformationsBloc>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Stripe",
              style: kTitle1Bold,
            ),
            const SizedBox(height: kPadding10),
            Text(
              "rociny_stripe_payment".translate(),
              style: kBody.copyWith(color: kGrey300),
            ),
            const SizedBox(height: kPadding20),
            if (!bloc.isStripeAccountCompleted)
              ChipButton(
                label: "start".translate(),
                onTap: () async {
                  CompleteLegalInformationsBloc bloc = context.read<CompleteLegalInformationsBloc>();
                  if (bloc.stripeAccountUrl == null && state is! GetStripeAccountLinkLoading) {
                    bloc.add(GetStripeAccountLink());
                  }
                },
              ),
            const Spacer(),
          ],
        );
      },
    );
  }
}
