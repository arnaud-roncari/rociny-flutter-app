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
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/company/collaborations/data/enum/collaboration_status.dart';
import 'package:rociny/features/company/collaborations/ui/widgets/notation.dart';
import 'package:rociny/features/company/collaborations/ui/widgets/status_modal.dart';
import 'package:rociny/features/company/search/data/models/product_placement_model.dart';
import 'package:rociny/features/company/search/data/models/review_model.dart';
import 'package:rociny/features/company/search/ui/widgets/billing_informations.dart';
import 'package:rociny/features/company/search/ui/widgets/file_card.dart';
import 'package:rociny/features/company/search/ui/widgets/product_placement_card.dart';
import 'package:rociny/features/influencer/collaborations/bloc/collaboration_bloc.dart';
import 'package:rociny/shared/decorations/container_shadow_decoration.dart';
import 'package:rociny/shared/widgets/button.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

class CollaborationPage extends StatefulWidget {
  final int userId;
  final int collaborationId;
  const CollaborationPage({
    super.key,
    required this.userId,
    required this.collaborationId,
  });

  @override
  State<CollaborationPage> createState() => _CollaborationPageState();
}

class _CollaborationPageState extends State<CollaborationPage> {
  @override
  void initState() {
    context.read<CollaborationBloc>().add(
          Initialize(
            userId: widget.userId,
            collaborationId: widget.collaborationId,
          ),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: BlocConsumer<CollaborationBloc, CollaborationState>(
          listener: (context, state) {
            if (state is InitializeFailed) {
              Alert.showError(context, state.exception.message);
            }

            if (state is AcceptCollaborationFailed) {
              Alert.showError(context, state.exception.message);
            }

            if (state is RefuseCollaborationFailed) {
              Alert.showError(context, state.exception.message);
            }

            if (state is EndCollaborationFailed) {
              Alert.showError(context, state.exception.message);
            }
          },
          builder: (context, state) {
            if (state is InitializeLoading ||
                state is AcceptCollaborationLoading ||
                state is RefuseCollaborationLoading ||
                state is EndCollaborationLoading ||
                state is InitializeFailed) {
              return Center(
                child: CircularProgressIndicator(
                  color: kPrimary500,
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: kPadding20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kPadding20),
                  child: Row(
                    children: [
                      SvgButton(
                        path: "assets/svg/left_arrow.svg",
                        color: kBlack,
                        onPressed: () {
                          context.pop();
                        },
                      ),
                      const SizedBox(width: kPadding30),
                      const Spacer(),
                      Text(
                        "Collaboration",
                        style: kTitle1Bold,
                      ),
                      const Spacer(),
                      SvgButton(
                        path: "assets/svg/info.svg",
                        color: kBlack,
                        onPressed: () {
                          final bloc = context.read<CollaborationBloc>();
                          final status = CollaborationStatus.fromString(bloc.collaboration.status);
                          showModalBottomSheet(
                            context: context,
                            isDismissible: true,
                            backgroundColor: kWhite,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(kRadius20)),
                            ),
                            builder: (BuildContext context) {
                              return StatusModal(status: status);
                            },
                          );
                        },
                      ),
                      const SizedBox(width: kPadding10),
                      PopupMenuButton<String>(
                        borderRadius: BorderRadius.circular(kRadius100),
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
                          return getPopupMenuItems();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: kPadding15),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: kPadding15),
                        buildStatus(),
                        buildCollaborationDetails(),
                        buildActions(),
                        const SizedBox(height: kPadding20),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildActions() {
    final bloc = context.read<CollaborationBloc>();
    final status = CollaborationStatus.fromString(bloc.collaboration.status);

    if (status == CollaborationStatus.sentByCompany) {
      return buildAcceptAndRefuseButtons();
    }

    if (status == CollaborationStatus.inProgress) {
      return buildInProgressButton();
    }

    if (status == CollaborationStatus.done) {
      return buildBillsAndReview();
    }

    return Container();
  }

  Widget buildBillsAndReview() {
    final bloc = context.read<CollaborationBloc>();
    final collaborationId = bloc.collaboration.id;
    final Review? review = bloc.review;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: kPadding30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPadding20),
          child: Text(
            "Juridique",
            style: kTitle1Bold,
          ),
        ),
        const SizedBox(height: kPadding10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPadding20),
          child: Text(
            "Téléchargez vos factures.",
            style: kBody.copyWith(color: kGrey300),
          ),
        ),
        const SizedBox(height: kPadding20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPadding20),
          child: Container(
            width: MediaQuery.of(context).size.width - 60,
            height: 80,
            decoration: kContainerShadow,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(kPadding10),
                onTap: () {
                  context.push("/preview_pdf/network",
                      extra: "$kEndpoint/influencer/collaborations/$collaborationId/influencer-invoice");
                },
                child: Padding(
                  padding: const EdgeInsets.all(kPadding20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Facture",
                          style: kTitle2Bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (review != null)
          Padding(
            padding: const EdgeInsets.only(left: kPadding20, top: kPadding30, right: kPadding20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Évaluation",
                  style: kTitle1Bold,
                ),
                const SizedBox(height: kPadding10),
                Text(
                  "Évaluation laissée par l'influenceur.",
                  style: kBody.copyWith(color: kGrey300),
                ),
                const SizedBox(height: kPadding20),
                Notation(stars: review.stars),
                const SizedBox(height: kPadding10),
                Text(
                  review.description ?? "",
                  style: kBody.copyWith(color: kBlack),
                ),
              ],
            ),
          ),
        if (!bloc.hasReviewed)
          Padding(
            padding: const EdgeInsets.only(left: kPadding20, top: kPadding30, right: kPadding20),
            child: Button(
              title: "Évaluer",
              onPressed: () {
                context.push("/influencer/home/preview_collaboration/review");
              },
            ),
          ),
      ],
    );
  }

  List<PopupMenuItem<String>> getPopupMenuItems() {
    final bloc = context.read<CollaborationBloc>();
    final collaborationId = bloc.collaboration.id;

    final influencerQuote = PopupMenuItem<String>(
      value: "influencer_quote",
      child: Text(
        "Devis",
        style: kBody,
      ),
      onTap: () {
        context.push("/preview_pdf/network",
            extra: "$kEndpoint/influencer/collaborations/$collaborationId/influencer-quote");
      },
    );

    return [
      influencerQuote,
    ];
  }

  Widget buildAcceptAndRefuseButtons() {
    return Padding(
      padding: const EdgeInsets.only(
        left: kPadding20,
        right: kPadding20,
        top: kPadding30,
      ),
      child: Column(
        children: [
          Button(
            title: "Valider",
            onPressed: () {
              context.read<CollaborationBloc>().add(AcceptCollaboration());
            },
          ),
          const SizedBox(height: kPadding10),
          Button(
            backgroundColor: kBlack,
            title: "Refuser",
            onPressed: () {
              context.read<CollaborationBloc>().add(RefuseCollaboration());
            },
          ),
        ],
      ),
    );
  }

  Widget buildInProgressButton() {
    return Padding(
      padding: const EdgeInsets.only(
        left: kPadding20,
        right: kPadding20,
        top: kPadding30,
      ),
      child: Button(
        title: "Terminer",
        onPressed: () {
          context.read<CollaborationBloc>().add(EndCollaboration());
        },
      ),
    );
  }

  Widget buildCollaborationDetails() {
    final bloc = context.read<CollaborationBloc>();
    final collaboration = bloc.collaboration;
    final productPlacements = collaboration.productPlacements;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPadding20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: kPadding15),
              LayoutBuilder(builder: (context, constraints) {
                return InkWell(
                  onTap: () {
                    context.push("/influencer/home/preview", extra: bloc.company.userId);
                  },
                  child: SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxWidth / 2,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(kPadding10),
                      ),
                      child: Image(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                          "$kEndpoint/company/profile-pictures/${bloc.company.profilePicture}",
                          headers: {"Authorization": "Bearer $kJwt"},
                        ),
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: kPadding30),
              Text(
                "placements".translate(),
                style: kTitle1Bold,
              ),
              const SizedBox(height: kPadding10),
              Text(
                "placements_instruction".translate(),
                style: kBody.copyWith(color: kGrey300),
              ),
            ],
          ),
        ),
        Builder(builder: (context) {
          List<Widget> children = [];
          for (ProductPlacement pp in productPlacements) {
            children.add(
              Padding(
                padding: const EdgeInsets.only(left: kPadding20),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 60,
                  child: ProductPlacementCard(
                    productPlacement: pp,
                  ),
                ),
              ),
            );
          }
          children.add(const SizedBox(width: kPadding20));

          return SizedBox(
            height: 120,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: children,
              ),
            ),
          );
        }),
        if (collaboration.files.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPadding20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: kPadding10),
                    Text(
                      "file".translate(),
                      style: kTitle1Bold,
                    ),
                    const SizedBox(height: kPadding10),
                    Text(
                      "file_instruction".translate(),
                      style: kBody.copyWith(color: kGrey300),
                    ),
                  ],
                ),
              ),
              Builder(
                builder: (context) {
                  List<Widget> children = [];
                  for (String url in collaboration.files) {
                    children.add(
                      Padding(
                        padding: const EdgeInsets.only(left: kPadding20),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 60,
                          child: FileCard(
                            url: "$kEndpoint/influencer/collaborations/files/$url",
                          ),
                        ),
                      ),
                    );
                  }
                  children.add(const SizedBox(width: kPadding20));

                  return SizedBox(
                    height: 120,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: children,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        const SizedBox(height: kPadding10),
        buildBill(),
      ],
    );
  }

  Widget buildBill() {
    final bloc = context.read<CollaborationBloc>();
    final collaboration = bloc.collaboration;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPadding20),
      child: BillingInformations(
        collaboration: collaboration,
        company: bloc.company,
        influencer: bloc.influencer,
      ),
    );
  }

  Widget buildStatus() {
    final bloc = context.read<CollaborationBloc>();
    final status = CollaborationStatus.fromString(bloc.collaboration.status);

    late Widget child;

    if (status == CollaborationStatus.sentByCompany) {
      child = Text(
        "Nouvelle",
        style: kBody.copyWith(color: kPrimary500),
      );
    }
    if (status == CollaborationStatus.refusedByInfluencer) {
      child = Text(
        "Collaboration refusée.",
        style: kBody.copyWith(color: kRed500),
      );
    }
    if (status == CollaborationStatus.canceledByCompany) {
      child = Text(
        "Collaboration annulée.",
        style: kBody.copyWith(color: kRed500),
      );
    }
    if (status == CollaborationStatus.waitingForCompanyPayment) {
      child = Text(
        "En attente de paiement.",
        style: kBody.copyWith(color: kOrange500),
      );
    }

    if (status == CollaborationStatus.inProgress) {
      child = Text(
        "Collaboration en cours.",
        style: kBody.copyWith(color: kRed500),
      );
    }

    if (status == CollaborationStatus.pendingCompanyValidation) {
      child = Text(
        "En attente de validation.",
        style: kBody.copyWith(color: kRed500),
      );
    }

    if (status == CollaborationStatus.done) {
      child = Text(
        "Collaboration terminée.",
        style: kBody.copyWith(color: kGreen500),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPadding20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Statut", style: kTitle1Bold),
          const SizedBox(height: kPadding10),
          child,
        ],
      ),
    );
  }
}
