import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/shared/decorations/container_shadow_decoration.dart';

class FileCard extends StatelessWidget {
  final void Function(File file)? onRemoved;
  final File? file;
  final String? url;
  const FileCard({super.key, this.onRemoved, this.file, this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: kContainerShadow,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(kPadding10),
          onTap: () {
            if (file != null) {
              context.push('/preview_pdf', extra: file);
            } else if (url != null) {
              context.push("/preview_pdf/network", extra: "$kEndpoint/company/collaboration-file/$url");
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(kPadding20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    getFileName(),
                    style: kTitle2Bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (onRemoved != null)
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
                          value: "delete",
                          child: Text(
                            "Supprimer",
                            style: kBody,
                          ),
                          onTap: () {
                            onRemoved!(file!);
                          },
                        ),
                      ];
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getFileName() {
    if (file != null) {
      return basenameWithoutExtension(file!.path);
    } else if (url != null) {
      return url!.split('-').first;
    }
    return '';
  }
}
