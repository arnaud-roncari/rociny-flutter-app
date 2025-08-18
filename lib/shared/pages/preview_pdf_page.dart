import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/shared/widgets/svg_button.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PreviewPdfPage extends StatelessWidget {
  final File file;
  const PreviewPdfPage({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kWhite,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: kPadding20, top: kPadding20, bottom: kPadding20),
                child: SvgButton(
                  path: "assets/svg/left_arrow.svg",
                  color: kBlack,
                  onPressed: () {
                    context.pop();
                  },
                ),
              ),
              Expanded(
                child: SfPdfViewer.file(
                  file,
                ),
              ),
            ],
          ),
        ));
  }
}
