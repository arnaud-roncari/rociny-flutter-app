import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/shared/decorations/container_shadow_decoration.dart';

class FileCard extends StatelessWidget {
  final void Function(File file)? onRemoved;
  final File file;
  const FileCard({super.key, this.onRemoved, required this.file});

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
            context.push('/preview_pdf', extra: file);
          },
          child: Padding(
            padding: const EdgeInsets.all(kPadding20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    basenameWithoutExtension(file.path),
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
                            onRemoved!(file);
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
}
