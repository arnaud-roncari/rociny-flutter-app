import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

class PreviewPicturePage extends StatelessWidget {
  final String endpoint;
  final void Function()? onDeleted;
  const PreviewPicturePage({super.key, required this.endpoint, this.onDeleted});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: kPadding20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPadding20),
                child: Row(
                  children: [
                    SvgButton(
                      path: "assets/svg/left_arrow.svg",
                      color: kWhite,
                      onPressed: () {
                        context.pop();
                      },
                    ),
                    const Spacer(),
                    if (onDeleted != null)
                      SvgButton(
                        path: "assets/svg/trash.svg",
                        color: kWhite,
                        onPressed: () {
                          onDeleted!();
                          context.pop();
                        },
                      ),
                  ],
                ),
              ),
              const Spacer(),
              LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth;
                  return SizedBox(
                    width: maxWidth,
                    height: maxWidth,
                    child: Image(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                        endpoint,
                        headers: {"Authorization": "Bearer $kJwt"},
                      ),
                    ),
                  );
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
