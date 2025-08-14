import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/company/search/bloc/preview/preview_bloc.dart';
import 'package:rociny/features/company/search/ui/widgets/file_card.dart';
import 'package:rociny/shared/widgets/button.dart';
import 'package:rociny/shared/widgets/chip_button.dart';

class FileForm extends StatefulWidget {
  const FileForm({super.key});

  @override
  State<FileForm> createState() => _FileFormState();
}

class _FileFormState extends State<FileForm> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PreviewBloc, PreviewState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPadding20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Fichiers", style: kTitle1Bold),
              const SizedBox(height: kPadding10),
              Text(
                "Ajoutez des fichiers pour assurer le bon déroulement de la collaboration.",
                style: kBody.copyWith(color: kGrey300),
              ),
              const SizedBox(height: kPadding20),
              ChipButton(
                svgPath: "assets/svg/add.svg",
                onTap: () {
                  context.read<PreviewBloc>().add(PickFiles());
                },
                label: "Nouveau fichier",
              ),
              const SizedBox(height: kPadding30),
              Builder(builder: (context) {
                final bloc = context.read<PreviewBloc>();
                List<Widget> children = [];
                for (File file in bloc.files) {
                  children.add(
                    Padding(
                      padding: const EdgeInsets.only(bottom: kPadding20),
                      child: FileCard(
                        onRemoved: (file) {
                          bloc.add(RemoveFile(file: file));
                        },
                        file: file,
                      ),
                    ),
                  );
                }
                return Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: children,
                    ),
                  ),
                );
              }),
              buildButton(),
              const SizedBox(height: kPadding20),
            ],
          ),
        );
      },
    );
  }

  Widget buildButton() {
    return Button(
      title: "continue".translate(),
      onPressed: () {
        context.read<PreviewBloc>().add(UpdateStep(index: 4));
      },
    );
  }
}
