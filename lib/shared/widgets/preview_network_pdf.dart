import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/shared/widgets/svg_button.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:uuid/uuid.dart';

class PreviewNetworkPdfPage extends StatelessWidget {
  final String url;
  const PreviewNetworkPdfPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kWhite,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: kPadding20, top: kPadding20, bottom: kPadding20, right: kPadding20),
                child: Row(
                  children: [
                    SvgButton(
                      path: "assets/svg/left_arrow.svg",
                      color: kBlack,
                      onPressed: () {
                        context.pop();
                      },
                    ),
                    const Spacer(),
                    PopupMenuButton<String>(
                      tooltip: "",
                      padding: EdgeInsets.zero,
                      menuPadding: EdgeInsets.zero,
                      color: kWhite,
                      child: SvgPicture.asset(
                        "assets/svg/menu_vertical.svg",
                        width: 20,
                        height: 20,
                      ),
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem<String>(
                            value: "download",
                            child: Text(
                              "Télécharger",
                              style: kBody,
                            ),
                            onTap: () {
                              downloadAndSharePdf(context, url);
                            },
                          ),
                        ];
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SfPdfViewer.network(
                  url,
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> downloadAndSharePdf(BuildContext context, String url) async {
    try {
      final response = await get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception(".");
      }

      final dir = await getApplicationDocumentsDirectory();
      final fileName = '${const Uuid().v4()}.pdf';
      final filePath = '${dir.path}/$fileName';

      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      await SharePlus.instance.share(
        ShareParams(
          text: 'Voici votre document PDF',
          files: [XFile(file.path)],
        ),
      );
    } catch (e) {
      Alert.showError(
        // ignore: use_build_context_synchronously
        context, "Impossible de télécharger le PDF. Veuillez réessayer plus tard.",
      );
    }
  }
}
