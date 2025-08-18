import 'package:flutter/widgets.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/auth/data/models/instagram_account_model.dart';
import 'package:rociny/features/company/profile/data/models/company.dart';
import 'package:rociny/features/influencer/complete_profile/ui/widgets/social_network_card.dart';
import 'package:rociny/shared/widgets/instagram_statistics.dart';

class CompanyProfile extends StatefulWidget {
  final Company company;
  final InstagramAccount? instagramAccount;
  const CompanyProfile({super.key, required this.company, this.instagramAccount});

  @override
  State<CompanyProfile> createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildProfilePicture(),
        buildName(),
        buildGeolocation(),
        buildStars(),
        buildDescription(),
        buildSocialNetworks(),
        buildInstagram(),
        buildComments(),
        buildInfluencers(),
      ],
    );
  }

  Widget buildProfilePicture() {
    final Company company = widget.company;

    if (company.profilePicture == null) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding30),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kRadius10),
            ),
            width: constraints.maxWidth,
            height: constraints.maxWidth / 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(kRadius10),
              child: Image(
                image: NetworkImage(
                  "$kEndpoint/company/get-profile-picture/${company.profilePicture!}",
                  headers: {
                    'Authorization': 'Bearer $kJwt',
                  },
                ),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildName() {
    final Company company = widget.company;

    if (company.name == null) {
      return Container();
    }

    return Text(
      company.name!,
      style: kHeadline5Bold,
    );
  }

  Widget buildGeolocation() {
    final Company company = widget.company;

    if (company.department == null) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding5),
      child: Text(
        company.department!,
        style: kBody.copyWith(color: kGrey300),
      ),
    );
  }

  /// TODO ajouter moyenne star
  Widget buildStars() {
    /// And  amount of collaboration
    // return Text("0 Collaborations", style: kBody);
    return Container();
  }

  Widget buildDescription() {
    final Company company = widget.company;

    if (company.description == null) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding20),
      child: Text(
        company.description!,
        style: kBody,
      ),
    );
  }

  Widget buildSocialNetworks() {
    final Company company = widget.company;

    if (company.socialNetworks.isEmpty) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: company.socialNetworks.map((sn) {
          return SocialNetworkCard(socialNetwork: sn);
        }).toList(),
      ),
    );
  }

  Widget buildInstagram() {
    if (widget.instagramAccount == null) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding30),
      child: InstagramStatistics(
        instagramAccount: widget.instagramAccount!,
      ),
    );
  }

  /// TODO ajouter influencuer
  Widget buildInfluencers() {
    return Container();
  }

  /// TODO ajouter reviews
  Widget buildComments() {
    return Padding(
      padding: const EdgeInsets.only(bottom: kPadding30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("comments".translate(), style: kTitle1Bold),
          const SizedBox(height: kPadding10),
          Text(
            "collaborate_for_comments".translate(),
            style: kBody.copyWith(color: kGrey300),
          ),
          const SizedBox(height: kPadding30),
        ],
      ),
    );
  }
}
