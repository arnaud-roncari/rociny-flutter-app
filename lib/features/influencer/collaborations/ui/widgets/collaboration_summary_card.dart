import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/features/company/collaborations/data/model/collaboration_summary_model.dart';
import 'package:rociny/shared/decorations/container_shadow_decoration.dart';

class CollaborationSummaryCard extends StatelessWidget {
  final CollaborationSummary summary;
  const CollaborationSummaryCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        decoration: kContainerShadow,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(kPadding10),
            onTap: () {
              context.push("/influencer/home/preview_collaboration", extra: {
                "user_id": summary.companyUserId,
                "collaboration_id": summary.collaborationId,
              });
            },
            child: Column(
              children: [
                SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxWidth / 2,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(kPadding10),
                      topRight: Radius.circular(kPadding10),
                    ),
                    child: Image(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                        "$kEndpoint/company/profile-pictures/${summary.companyProfilePicture}",
                        headers: {"Authorization": "Bearer $kJwt"},
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(kPadding20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        summary.collaborationTitle,
                        style: kHeadline5Bold,
                      ),
                      const SizedBox(height: kPadding5),
                      Text(
                        summary.companyName,
                        style: kBody,
                      ),
                      const SizedBox(height: kPadding20),
                      Row(
                        children: [
                          Text(
                            "${summary.placementsCount} Tâches",
                            style: kCaption.copyWith(color: kGrey300),
                          ),
                          const Spacer(),
                          Text(
                            "${summary.getPrice()} €",
                            style: kBody,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
