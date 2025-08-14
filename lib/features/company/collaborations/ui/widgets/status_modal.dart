import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/company/collaborations/data/enum/collaboration_status.dart';
import 'package:rociny/shared/widgets/button.dart';

class StatusModal extends StatelessWidget {
  final CollaborationStatus status;
  const StatusModal({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kPadding20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(getStatus(), style: kTitle1Bold),
          const SizedBox(height: kPadding10),
          Text(
            getDescription(),
            style: kBody.copyWith(color: kGrey300),
          ),
          const SizedBox(height: kPadding30),
          Button(
              title: "ok".translate(),
              onPressed: () {
                context.pop();
              }),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  String getDescription() {
    switch (status) {
      case CollaborationStatus.draft:
        return "La collaboration est en brouillon et n'a pas encore été envoyée.";
      case CollaborationStatus.sentByCompany:
        return "La collaboration a été envoyée à l'influenceur.";
      case CollaborationStatus.refusedByInfluencer:
        return "L'influenceur a refusé la collaboration.";
      case CollaborationStatus.canceledByCompany:
        return "La collaboration a été annulée.";
      case CollaborationStatus.waitingForCompanyPayment:
        return "En attente du paiement de l'entreprise.";
      case CollaborationStatus.inProgress:
        return "La collaboration est actuellement en cours. L'influenceur doit terminer ses missions.";
      case CollaborationStatus.pendingCompanyValidation:
        return "L'influenceur a terminé ses missions. En attente de validation par l'entreprise. ";
      case CollaborationStatus.done:
        return "La collaboration est terminée.";
    }
  }

  String getStatus() {
    if (status == CollaborationStatus.draft) {
      return "Brouillon";
    }
    if (status == CollaborationStatus.sentByCompany) {
      return "Collaboration envoyé";
    }
    if (status == CollaborationStatus.refusedByInfluencer) {
      return "Collaboration refusée";
    }
    if (status == CollaborationStatus.canceledByCompany) {
      return "Collaboration annulée";
    }
    if (status == CollaborationStatus.waitingForCompanyPayment) {
      return "En attente de paiement";
    }

    if (status == CollaborationStatus.inProgress) {
      return "Collaboration en cours";
    }

    if (status == CollaborationStatus.pendingCompanyValidation) {
      return "En attente de validation";
    }

    return "Collaboration terminée";
  }
}
