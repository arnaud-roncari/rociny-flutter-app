import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/company/search/bloc/preview/preview_bloc.dart';
import 'package:rociny/shared/decorations/textfield_decoration.dart';
import 'package:rociny/shared/widgets/button.dart';

class TitleForm extends StatefulWidget {
  const TitleForm({super.key});

  @override
  State<TitleForm> createState() => _TitleFormState();
}

class _TitleFormState extends State<TitleForm> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    final bloc = context.read<PreviewBloc>();
    final collaboration = bloc.collaboration;
    controller.text = collaboration.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PreviewBloc>();
    final collaboration = bloc.collaboration;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPadding20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Titre", style: kTitle1Bold),
          const SizedBox(height: kPadding10),
          Text(
            "Formulez un titre clair et concis qui résume votre collaboration. Assurez-vous qu'il reflète précisément vos objectifs et votre vision.",
            style: kBody.copyWith(color: kGrey300),
          ),
          const SizedBox(height: kPadding20),
          TextField(
            controller: controller,
            decoration: kTextFieldDecoration.copyWith(
              hintText: "Title",
            ),
            onChanged: (value) {
              setState(() {
                collaboration.title = value;
              });
            },
            maxLength: 100,
            style: kBody,
          ),
          const Spacer(),
          buildButton(),
          const SizedBox(height: kPadding20),
        ],
      ),
    );
  }

  Widget buildButton() {
    final bloc = context.read<PreviewBloc>();
    final collaboration = bloc.collaboration;
    if (collaboration.title.isEmpty) {
      return Button(
        // ignore: deprecated_member_use
        backgroundColor: kPrimary500.withOpacity(0.5),
        title: "continue".translate(),
        onPressed: () {},
      );
    }

    return Button(
      title: "continue".translate(),
      onPressed: () {
        context.read<PreviewBloc>().add(UpdateStep(index: 2));
      },
    );
  }
}
