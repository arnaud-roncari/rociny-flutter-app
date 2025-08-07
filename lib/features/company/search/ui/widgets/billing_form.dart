import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/company/profile/data/models/company.dart';
import 'package:rociny/features/company/search/bloc/preview/preview_bloc.dart';
import 'package:rociny/shared/widgets/button.dart';

class BillingForm extends StatefulWidget {
  const BillingForm({super.key});

  @override
  State<BillingForm> createState() => _BillingFormState();
}

class _BillingFormState extends State<BillingForm> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PreviewBloc>();
    Company company = bloc.company;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPadding20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("billing".translate(), style: kTitle1Bold),
          const SizedBox(height: kPadding10),
          Text(
            "verify_company_info".translate(),
            style: kBody.copyWith(color: kGrey300),
          ),
          const SizedBox(height: kPadding20),
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: kGrey100, width: 0.5),
              borderRadius: BorderRadius.circular(kRadius10),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(kPadding20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "company".translate(),
                    style: kTitle2Bold,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      SizedBox(
                        height: 25,
                        width: 25,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(kRadius100),
                          child: Image(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                              "$kEndpoint/company/get-profile-picture",
                              headers: {"Authorization": "Bearer $kJwt"},
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: kPadding10),
                      Text(
                        company.name!,
                        style: kBody,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: kPadding20),
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: kGrey100, width: 0.5),
              borderRadius: BorderRadius.circular(kRadius10),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(kPadding20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Adresse",
                    style: kTitle2Bold,
                  ),
                  const Spacer(),

                  /// TODO ajouter l'adresse dans juridique ?
                  Text(
                    "7 Rue du X, XXXX Ville, France",
                    style: kBody,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: kPadding5),
          Row(
            children: [
              const Spacer(),
              Text(
                "${"edit_in_settings_part1".translate()} ",
                style: kCaption.copyWith(color: kGrey300),
              ),
              InkWell(
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  context.push("/company/home/settings");
                },
                child: Text(
                  "edit_in_settings_part1".translate(),
                  style: kCaptionBold.copyWith(color: kPrimary500),
                ),
              ),
            ],
          ),
          const Spacer(),
          buildButton(),
          const SizedBox(height: kPadding20),
        ],
      ),
    );
  }

  Widget buildButton() {
    return Button(
      title: "continue".translate(),
      onPressed: () {
        context.read<PreviewBloc>().add(UpdateStep(index: 1));
      },
    );
  }
}
