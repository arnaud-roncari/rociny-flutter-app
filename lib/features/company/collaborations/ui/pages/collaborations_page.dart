import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/company/collaborations/bloc/collaborations_bloc.dart';
import 'package:rociny/features/company/collaborations/data/enum/collaboration_status.dart';
import 'package:rociny/features/company/collaborations/ui/widgets/collaboration_summary_card.dart';

/// TODO faire une global commsiision roiciny a set dans le main depuis backedn. (dans colalb, ajouter la commision)
class CollaborationsPage extends StatefulWidget {
  const CollaborationsPage({super.key});

  @override
  State<CollaborationsPage> createState() => _CollaborationsPageState();
}

class _CollaborationsPageState extends State<CollaborationsPage> with AutomaticKeepAliveClientMixin {
  CollaborationStatus selectedStatus = CollaborationStatus.inProgress;
  @override
  void initState() {
    super.initState();
    context.read<CollaborationsBloc>().add(Initialize());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: kPadding20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPadding20),
          child: Text(
            "collaborations".translate(),
            style: kHeadline4Bold,
          ),
        ),
        BlocConsumer<CollaborationsBloc, CollaborationsState>(
          listener: (context, state) {
            if (state is InitializeFailed) {
              Alert.showError(context, state.exception.message);
            }
          },
          builder: (context, state) {
            final bloc = context.read<CollaborationsBloc>();

            ///..
            return Expanded(
              child: Column(
                children: [
                  const SizedBox(height: kPadding30),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const SizedBox(width: kPadding20),
                        buildTag("En cours", CollaborationStatus.inProgress),
                        const SizedBox(width: kPadding10),
                        buildTag("Brouillon", CollaborationStatus.draft),
                        const SizedBox(width: kPadding10),
                        buildTag("Envoyées", CollaborationStatus.sentByCompany),
                        const SizedBox(width: kPadding10),
                        buildTag("Refusées", CollaborationStatus.refusedByInfluencer),
                        const SizedBox(width: kPadding10),
                        buildTag("Annulées", CollaborationStatus.canceledByCompany),
                        const SizedBox(width: kPadding10),
                        buildTag("En attente du paiement", CollaborationStatus.waitingForCompanyPayment),
                        const SizedBox(width: kPadding10),
                        buildTag("En attente de validation", CollaborationStatus.pendingCompanyValidation),
                        const SizedBox(width: kPadding10),
                        buildTag("Terminées", CollaborationStatus.done),
                        const SizedBox(width: kPadding20),
                      ],
                    ),
                  ),
                  const SizedBox(height: kPadding20),
                  Builder(builder: (context) {
                    if (state is InitializeLoading) {
                      return Expanded(
                        child: Column(
                          children: [
                            const Spacer(),
                            Center(
                              child: CircularProgressIndicator(
                                color: kPrimary500,
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      );
                    }

                    final summaries = getSummariesByStatus(bloc);

                    if (summaries.isEmpty) {
                      return Expanded(
                        child: Column(
                          children: [
                            const Spacer(),
                            Text(
                              "Aucune collaboration",
                              style: kBodyBold.copyWith(color: kGrey300),
                            ),
                            const SizedBox(height: kPadding5),
                            Text(
                              "Vous n'avez reçu aucune proposition de collaboration.",
                              style: kBody.copyWith(color: kGrey300),
                            ),
                            const Spacer(),
                          ],
                        ),
                      );
                    }

                    return Expanded(
                      child: RefreshIndicator(
                        backgroundColor: kWhite,
                        elevation: 0,
                        color: kPrimary500,
                        onRefresh: () async {
                          bloc.add(Initialize());
                        },
                        child: ListView.builder(
                          itemCount: summaries.length,
                          itemBuilder: (context, index) {
                            final collaboration = summaries[index];

                            return Padding(
                              padding: const EdgeInsets.only(
                                left: kPadding20,
                                right: kPadding20,
                                bottom: kPadding20,
                              ),
                              child: CollaborationSummaryCard(summary: collaboration),
                            );
                          },
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  List<dynamic> getSummariesByStatus(CollaborationsBloc bloc) {
    return bloc.summaries.where((summary) => summary.collaborationStatus == selectedStatus).toList();
  }

  Widget buildTag(String tag, CollaborationStatus status) {
    bool isSelected = status == selectedStatus;

    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: isSelected ? kPrimary500 : kWhite,
        borderRadius: BorderRadius.circular(kRadius100),
        border: isSelected
            ? null
            : Border.all(
                color: kGrey100,
                width: 0.5,
              ),
      ),
      child: InkWell(
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        borderRadius: BorderRadius.circular(kRadius100),
        onTap: () {
          setState(() {
            selectedStatus = status;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPadding15),
          child: Center(
            child: Text(
              tag,
              style: isSelected ? kCaptionBold.copyWith(color: kWhite) : kCaption,
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
