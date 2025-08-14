import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/auth/data/models/review_model.dart';
import 'package:rociny/features/company/collaborations/bloc/collaboration_bloc.dart';
import 'package:rociny/features/company/collaborations/data/enum/collaboration_status.dart';
import 'package:rociny/features/company/collaborations/ui/widgets/notation.dart';
import 'package:rociny/features/company/collaborations/ui/widgets/status_modal.dart';
import 'package:rociny/features/company/search/data/models/influencer_summary_model.dart';
import 'package:rociny/features/company/search/data/models/product_placement_model.dart';
import 'package:rociny/features/company/search/ui/widgets/file_card.dart';
import 'package:rociny/features/company/search/ui/widgets/influencer_summary_card.dart';
import 'package:rociny/features/company/search/ui/widgets/product_placement_card.dart';
import 'package:rociny/shared/decorations/container_shadow_decoration.dart';
import 'package:rociny/shared/widgets/button.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

/// TODO fix padding nav bar page profil (inf et entreprise) (padding de 20 mal palcé)

/// TODO ajouter la modal (annuler, télécharger devis..) get aciton selon status)
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

            if (state is CancelCollaborationFailed) {
              Alert.showError(context, state.exception.message);
            }

            if (state is SendDraftCollaborationFailed) {
              Alert.showError(context, state.exception.message);
            }

            if (state is SupplyCollaborationFailed) {
              Alert.showError(context, state.exception.message);
            }

            if (state is ValidateCollaborationFailed) {
              Alert.showError(context, state.exception.message);
            }
          },
          builder: (context, state) {
            if (state is InitializeLoading ||
                state is CancelCollaborationLoading ||
                state is SendDraftCollaborationLoading ||
                state is ValidateCollaborationLoading ||
                state is SupplyCollaborationLoading) {
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

    if (status == CollaborationStatus.draft) {
      return buildSendDraftCollaborationButton();
    }

    if (status == CollaborationStatus.waitingForCompanyPayment) {
      return buildSupplyCollaborationButton();
    }

    if (status == CollaborationStatus.pendingCompanyValidation) {
      return buildValidateCollaborationButton();
    }

    if (status == CollaborationStatus.done) {
      return buildBillsAndReview();
    }

    return Container();
  }

  Widget buildBillsAndReview() {
    final bloc = context.read<CollaborationBloc>();
    final Review? review = bloc.review;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPadding20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: kPadding30),
          Text(
            "Juridique",
            style: kTitle1Bold,
          ),
          const SizedBox(height: kPadding10),
          Text(
            "Téléchargez votre facture.",
            style: kBody.copyWith(color: kGrey300),
          ),
          const SizedBox(height: kPadding20),
          Container(
            width: double.infinity,
            height: 80,
            decoration: kContainerShadow,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(kPadding10),
                onTap: () {
                  /// TODO preview facture (pov rociny qui facture entreprise)
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
          if (review != null)
            Padding(
              padding: const EdgeInsets.only(top: kPadding30),
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
                    review.description,
                    style: kBody.copyWith(color: kBlack),
                  ),
                ],
              ),
            ),
          if (!bloc.hasReviewed)
            Padding(
              padding: const EdgeInsets.only(top: kPadding30),
              child: Button(
                title: "Évaluer",
                onPressed: () {
                  context.push("/company/home/preview_collaboration/review");
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget buildValidateCollaborationButton() {
    return Padding(
      padding: const EdgeInsets.only(
        left: kPadding20,
        right: kPadding20,
        top: kPadding30,
      ),
      child: Button(
        title: "Valider",
        onPressed: () {
          context.read<CollaborationBloc>().add(ValidateCollaboration());
        },
      ),
    );
  }

  Widget buildSendDraftCollaborationButton() {
    return Padding(
      padding: const EdgeInsets.only(
        left: kPadding20,
        right: kPadding20,
        top: kPadding30,
      ),
      child: Button(
        title: "Proposer une collaboration",
        onPressed: () {
          context.read<CollaborationBloc>().add(SendDraftCollaboration());
        },
      ),
    );
  }

  Widget buildSupplyCollaborationButton() {
    return Padding(
      padding: const EdgeInsets.only(
        left: kPadding20,
        right: kPadding20,
        top: kPadding30,
      ),
      child: Button(
        title: "Approvisionner",
        onPressed: () {
          context.read<CollaborationBloc>().add(SupplyCollaboration());
        },
      ),
    );
  }

  List<PopupMenuItem<String>> getPopupMenuItems() {
    final bloc = context.read<CollaborationBloc>();
    final status = CollaborationStatus.fromString(bloc.collaboration.status);

    final cancel = PopupMenuItem<String>(
      value: "cancel",
      child: Text(
        "Annuler",
        style: kBody,
      ),
      onTap: () {
        bloc.add(CancelCollaboration());
      },
    );

    final quote = PopupMenuItem<String>(
      value: "quote",
      child: Text(
        "Télécharger le devis",
        style: kBody,
      ),
      onTap: () {
        /// TODO preview devis
      },
    );

    if (status == CollaborationStatus.draft) {
      return [
        quote,
      ];
    }
    if (status == CollaborationStatus.sentByCompany) {
      return [
        quote,
        cancel,
      ];
    }
    if (status == CollaborationStatus.refusedByInfluencer) {
      return [
        quote,
      ];
    }
    if (status == CollaborationStatus.canceledByCompany) {
      return [
        quote,
      ];
    }
    if (status == CollaborationStatus.waitingForCompanyPayment) {
      return [
        quote,
      ];
    }

    if (status == CollaborationStatus.inProgress) {
      return [
        quote,
      ];
    }

    if (status == CollaborationStatus.pendingCompanyValidation) {
      return [
        quote,
      ];
    }

    if (status == CollaborationStatus.done) {
      return [
        quote,
      ];
    }
    return [];
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
              InfluencerSummaryCard(
                influencer: InfluencerSummary.fromInfluencer(
                  bloc.influencer,
                  bloc.instagramAccount,
                ),
                onPressed: (_) {
                  /// TODO redirigier sur influenceuer
                },
              ),
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
                            url: url,
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
    final productPlacements = collaboration.productPlacements;

    int price = productPlacements.fold(
      0,
      (sum, pp) => sum + pp.price,
    );
    int total = (price * 1.05).round();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPadding20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("invoice".translate(), style: kTitle1Bold),
          const SizedBox(height: kPadding10),
          Row(
            children: [
              Text(
                "collaboration".translate(),
                style: kBody.copyWith(color: kGrey300),
              ),
              const Spacer(),
              Text(
                "$price €",
                style: kBody,
              ),
            ],
          ),
          const SizedBox(height: kPadding5),
          Row(
            children: [
              Text(
                "rociny_commission".translate(),
                style: kBody.copyWith(color: kGrey300),
              ),
              const Spacer(),
              Text(
                "5 %",
                style: kBody,
              ),
            ],
          ),
          const SizedBox(height: kPadding10),
          Row(
            children: [
              Text(
                "${"total".translate()} (EUR)",
                style: kBodyBold,
              ),
              const Spacer(),
              Text(
                "$total €",
                style: kBodyBold,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildStatus() {
    final bloc = context.read<CollaborationBloc>();
    final status = CollaborationStatus.fromString(bloc.collaboration.status);

    late Widget child;
    if (status == CollaborationStatus.draft) {
      child = Text(
        "Brouillon.",
        style: kBody.copyWith(color: kGrey300),
      );
    }
    if (status == CollaborationStatus.sentByCompany) {
      child = Text(
        "Collaboration envoyé.",
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
