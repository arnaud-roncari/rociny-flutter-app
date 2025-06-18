import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/constants/paddings.dart';

class PortfolioCarousel extends StatelessWidget {
  final List<String> pictures;
  final void Function(String pictureUrl) onPicturePressed;
  const PortfolioCarousel({super.key, required this.pictures, required this.onPicturePressed});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        const double gap = kPadding10;
        List<Widget> rows = [];
        int currentItem = 0;
        bool doubleRow = true;
        while (currentItem < pictures.length) {
          if (doubleRow) {
            if (currentItem + 1 < pictures.length) {
              final int leftIndex = currentItem;
              final int rightIndex = currentItem + 1;
              final double containerWidth = (maxWidth - gap) / 2;
              rows.add(Row(
                children: [
                  SizedBox(
                    width: containerWidth,
                    height: containerWidth,
                    child: InkWell(
                      onTap: () {
                        onPicturePressed(pictures[leftIndex]);
                      },
                      child: Image(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                          "$kEndpoint/influencer/get-portfolio/${pictures[leftIndex]}",
                          headers: {"Authorization": "Bearer $kJwt"},
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: gap),
                  SizedBox(
                    width: containerWidth,
                    height: containerWidth,
                    child: InkWell(
                      onTap: () {
                        onPicturePressed(pictures[rightIndex]);
                      },
                      child: Image(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                          "$kEndpoint/influencer/get-portfolio/${pictures[rightIndex]}",
                          headers: {"Authorization": "Bearer $kJwt"},
                        ),
                      ),
                    ),
                  ),
                ],
              ));
              currentItem += 2;
            } else {
              final double containerWidth = maxWidth;
              final int index = currentItem;
              rows.add(SizedBox(
                width: containerWidth,
                height: containerWidth,
                child: InkWell(
                  onTap: () {
                    onPicturePressed(pictures[index]);
                  },
                  child: Image(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      "$kEndpoint/influencer/get-portfolio/${pictures[index]}",
                      headers: {"Authorization": "Bearer $kJwt"},
                    ),
                  ),
                ),
              ));
              currentItem += 1;
            }
          } else {
            final int index = currentItem;
            rows.add(SizedBox(
              width: maxWidth,
              height: maxWidth,
              child: InkWell(
                onTap: () {
                  onPicturePressed(pictures[index]);
                },
                child: Image(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                    "$kEndpoint/influencer/get-portfolio/${pictures[index]}",
                    headers: {"Authorization": "Bearer $kJwt"},
                  ),
                ),
              ),
            ));
            currentItem += 1;
          }
          rows.add(const SizedBox(height: kPadding10));
          doubleRow = !doubleRow;
        }
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rows,
          ),
        );
      },
    );
  }
}
