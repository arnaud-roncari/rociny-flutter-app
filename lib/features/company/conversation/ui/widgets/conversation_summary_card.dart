import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/features/influencer/conversation/data/models/conversation_model.dart';

class ConversationSummaryCard extends StatelessWidget {
  final ConversationSummary summary;
  final void Function(ConversationSummary summary) onPressed;
  const ConversationSummaryCard({super.key, required this.summary, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        onPressed(summary);
      },
      child: SizedBox(
        height: 70,
        child: Column(
          children: [
            const SizedBox(
              height: kPadding10,
            ),
            SizedBox(
              height: 50,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      kRadius100,
                    ),
                    child: Image(
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                        "$kEndpoint/company/get-influencer-profile-picture/${summary.influencerProfilePicture}",
                        headers: {"Authorization": "Bearer $kJwt"},
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: kPadding10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: kPadding5),
                        Expanded(
                          child: Text(
                            summary.influencerName,
                            style: kTitle2,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            summary.lastMessage ?? "Collaboration",
                            style: kBody.copyWith(
                              color: kGrey300,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: kPadding40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(height: kPadding5),
                      Text(
                        summary.getTime(),
                        style: kCaption.copyWith(
                          color: kGrey300,
                        ),
                      ),
                      const SizedBox(height: kPadding10),
                      if (summary.influencerUnreadMessageCount > 0)
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: kPrimary500,
                            borderRadius: BorderRadius.circular(kRadius100),
                          ),
                          child: Center(
                            child: Text(
                              '${summary.influencerUnreadMessageCount}',
                              style: kCaption.copyWith(color: kWhite),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: kPadding20),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 70),
              child: Container(
                width: double.infinity,
                height: 1,
                // ignore: deprecated_member_use
                color: kBlack.withOpacity(0.1),
              ),
            )
          ],
        ),
      ),
    );
  }
}
