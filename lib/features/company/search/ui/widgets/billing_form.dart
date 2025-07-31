import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/company/search/bloc/preview/preview_bloc.dart';
import 'package:rociny/shared/widgets/button.dart';

class BillingForm extends StatefulWidget {
  const BillingForm({super.key});

  @override
  State<BillingForm> createState() => _BillingFormState();
}

class _BillingFormState extends State<BillingForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("billing".translate(), style: kTitle1Bold),
        const SizedBox(height: kPadding10),
        Text(
          "verify_company_info".translate(),
          style: kBody.copyWith(color: kGrey300),
        ),
        const Spacer(),
        buildButton(),
        const SizedBox(height: kPadding20),
      ],
    );
  }

  Widget buildButton() {
    return Button(
      title: "continue".translate(),
      onPressed: () {
        context.read<PreviewBloc>().add(UpdateStep(index: 1));
      },
    );
  }
}
