import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/features/company/collaborations/ui/widgets/collaboration_summary_card.dart';
import 'package:rociny/features/company/conversation/bloc/conversation_bloc.dart';
import 'package:rociny/features/influencer/conversation/data/models/message_model.dart';
import 'package:rociny/shared/decorations/textfield_decoration.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

class ConversationPage extends StatefulWidget {
  final int conversationId;
  final String influencerName;
  final String influencerProfilePicture;
  const ConversationPage(
      {super.key, required this.conversationId, required this.influencerName, required this.influencerProfilePicture});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<ConversationBloc>().add(Initialize(conversationId: widget.conversationId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: BlocConsumer<ConversationBloc, ConversationState>(
          listener: (context, state) {
            if (state is InitializeFailed) {
              Alert.showError(context, state.exception.message);
            }
          },
          builder: (context, state) {
            if (state is InitializeLoading || state is InitializeFailed) {
              return Center(
                child: CircularProgressIndicator(
                  color: kPrimary500,
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.only(left: kPadding20, right: kPadding20, top: kPadding20),
              child: Column(
                children: [
                  Row(
                    children: [
                      SvgButton(
                        path: "assets/svg/left_arrow.svg",
                        color: kBlack,
                        onPressed: () {
                          context.pop();
                        },
                      ),
                      const SizedBox(width: kPadding20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(kRadius100),
                        child: Image(
                          height: 30,
                          width: 30,
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                            "$kEndpoint/influencer/profile-pictures/${widget.influencerProfilePicture}",
                            headers: {"Authorization": "Bearer $kJwt"},
                          ),
                        ),
                      ),
                      const SizedBox(width: kPadding10),
                      Text(widget.influencerName, style: kTitle2),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: kPadding15),
                  buildMessages(),
                  buildBottomInput(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildMessages() {
    final messages = context.read<ConversationBloc>().messages;

    return Expanded(
      child: ListView.builder(
        reverse: true,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[messages.length - 1 - index];
          final isMine = message.senderType == "company";
          final isCollaboration = message.collaboration != null;

          // Previous message
          final prev = (index < messages.length - 1) ? messages[messages.length - 1 - (index + 1)] : null;
          final bool showDivider = prev == null ||
              message.createdAt.day != prev.createdAt.day ||
              message.createdAt.month != prev.createdAt.month ||
              message.createdAt.year != prev.createdAt.year;

          if (isCollaboration) {
            return Padding(
              padding: const EdgeInsets.only(bottom: kPadding20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (showDivider) buildDivider(message),
                  CollaborationSummaryCard(summary: message.collaboration!),
                  const SizedBox(height: kPadding10),
                  Text(
                    "Vous avez reçu une collaboration.",
                    style: kCaptionBold.copyWith(color: kPrimary500),
                  )
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: kPadding10),
            child: Column(
              children: [
                if (showDivider) buildDivider(message),
                buildMessage(message, isMine),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildMessage(Message message, bool isMine) {
    if (isMine) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.all(kPadding10),
          decoration: BoxDecoration(
            color: kPrimary500,
            borderRadius: BorderRadius.circular(kRadius10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                message.content ?? "",
                style: kBody.copyWith(color: kWhite),
              ),
              const SizedBox(height: kPadding10),
              Text(
                message.getTime(),
                style: kCaption.copyWith(color: kWhite),
              ),
            ],
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(kPadding10),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(246, 246, 246, 1),
          borderRadius: BorderRadius.circular(kRadius10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content ?? "",
              style: kBody.copyWith(color: kBlack),
            ),
            const SizedBox(height: kPadding10),
            Text(
              message.getTime(),
              style: kCaption.copyWith(color: kGrey100),
            )
          ],
        ),
      ),
    );
  }

  Widget buildBottomInput() {
    return SizedBox(
      height: 50,
      child: SizedBox(
        height: 30,
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 30,
                child: TextField(
                  controller: controller,
                  decoration: kTextFieldDecoration.copyWith(
                    contentPadding: const EdgeInsets.only(
                      left: kPadding10,
                    ),
                    hintText: "Aa",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kRadius100),
                      borderSide: BorderSide(
                        color: kGrey100,
                        width: 0.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kRadius100),
                      borderSide: BorderSide(
                        color: kGrey100,
                        width: 0.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kRadius100),
                      borderSide: BorderSide(
                        color: kGrey100,
                        width: 0.5,
                      ),
                    ),
                  ),
                  style: kBody,
                ),
              ),
            ),
            const SizedBox(width: kPadding10),
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: kPrimary500,
                borderRadius: BorderRadius.circular(kRadius100),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(kRadius100),
                  onTap: () {
                    if (controller.text.isEmpty) {
                      return;
                    }

                    context.read<ConversationBloc>().add(
                          AddMessage(
                            content: controller.text,
                            conversationId: widget.conversationId,
                          ),
                        );
                    setState(() {
                      controller.clear();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(kPadding5),
                    child: SvgPicture.asset(
                      "assets/svg/send.svg",
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(kWhite, BlendMode.srcIn),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildDivider(Message message) {
    return Padding(
      padding: const EdgeInsets.only(top: kPadding10, bottom: kPadding20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: kGrey100,
            ),
          ),
          const SizedBox(width: kPadding20),
          Text(
            message.getDayLabel(),
            style: kCaption.copyWith(color: kGrey300),
          ),
          const SizedBox(width: kPadding20),
          Expanded(
            child: Container(
              height: 1,
              color: kGrey100,
            ),
          ),
        ],
      ),
    );
  }
}
