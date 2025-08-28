import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/influencer/conversation/bloc/conversations_bloc.dart';
import 'package:rociny/features/influencer/conversation/data/models/conversation_model.dart';
import 'package:rociny/features/influencer/conversation/ui/widgets/conversation_summary_card.dart';

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({super.key});

  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();

    context.read<ConversationsBloc>().add(Initialize());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.only(left: kPadding20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: kPadding20),
          Text(
            "messaging".translate(),
            style: kHeadline4Bold,
          ),
          const SizedBox(height: kPadding15),
          Expanded(
            child: BlocConsumer<ConversationsBloc, ConversationsState>(
              listener: (context, state) {
                if (state is InitializeFailed) {
                  Alert.showError(context, state.exception.message);
                }
              },
              builder: (context, state) {
                final bloc = context.read<ConversationsBloc>();
                if (state is InitializeFailed || state is InitializeLoading) {
                  return Column(
                    children: [
                      const Spacer(),
                      Center(
                        child: CircularProgressIndicator(
                          color: kPrimary500,
                        ),
                      ),
                      const Spacer(),
                    ],
                  );
                }

                List<ConversationSummary> summaries = bloc.summaries;
                List<Widget> children = [];

                if (summaries.isEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        const Spacer(),
                        Text(
                          "Aucune conversation",
                          style: kBodyBold.copyWith(color: kGrey300),
                        ),
                        const SizedBox(height: kPadding5),
                        Text(
                          "Vous n'avez aucune conversation",
                          style: kBody.copyWith(color: kGrey300),
                        ),
                        const Spacer(),
                      ],
                    ),
                  );
                }

                for (var summary in summaries) {
                  children.add(
                    Padding(
                      padding: const EdgeInsets.only(bottom: kPadding15),
                      child: ConversationSummaryCard(
                        summary: summary,
                        onPressed: (summary) {
                          context.push("/influencer/home/conversation", extra: {
                            "conversation_id": summary.id,
                            "company_name": summary.companyName,
                            "company_profile_picture": summary.companyProfilePicture,
                          });
                        },
                      ),
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: kPadding15),
                      ...children,
                      const SizedBox(height: kPadding20),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
