import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/influencer/complete_register/bloc/complete_influencer_profile_informations/complete_influencer_profile_informations_bloc.dart';
import 'package:rociny/shared/widgets/button.dart';

class Instagram extends StatefulWidget {
  const Instagram({super.key});

  @override
  State<Instagram> createState() => _InstagramState();
}

class _InstagramState extends State<Instagram> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompleteInfluencerProfileInformationsBloc, CompleteInfluencerProfileInformationsState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Instagram",
              style: kTitle1Bold,
            ),
            const SizedBox(height: kPadding10),
            Text(
              "instagram_connect".translate(),
              style: kBody.copyWith(color: kGrey300),
            ),
            const Spacer(),
            Button(
              backgroundColor: kBlack,
              title: "connect".translate(),
              onPressed: () {},
            ),
            const SizedBox(height: kPadding10),
          ],
        );
      },
    );
  }
}
