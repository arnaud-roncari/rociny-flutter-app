import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/influencer/complete_register/bloc/complete_profile_informations/complete_profile_informations_bloc.dart';
import 'package:rociny/shared/widgets/chip_button.dart';

/// TODO faire un caroussel
class Portfolio extends StatefulWidget {
  const Portfolio({super.key});

  @override
  State<Portfolio> createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompleteProfileInformationsBloc, CompleteProfileInformationsState>(
      builder: (context, state) {
        CompleteProfileInformationsBloc bloc = context.read<CompleteProfileInformationsBloc>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Portfolio",
              style: kTitle1Bold,
            ),
            const SizedBox(height: kPadding10),
            Text(
              "publish_your_portfolio".translate(),
              style: kBody.copyWith(color: kGrey300),
            ),
            const SizedBox(height: kPadding20),
            ChipButton(
              label: "Portfolio",
              svgPath: "assets/svg/upload.svg",
              onTap: () async {
                context.read<CompleteProfileInformationsBloc>().add(UpdatePortfolio());
              },
            ),
            if (bloc.portfolio.isNotEmpty)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: kPadding20),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: kPadding20),
                    physics: const BouncingScrollPhysics(),
                    itemCount: bloc.portfolio.length,
                    itemBuilder: (context, index) {
                      final name = bloc.portfolio[index];
                      return LayoutBuilder(builder: (context, constraints) {
                        return Padding(
                          padding: EdgeInsets.only(
                            top: index == 0 ? 0 : kPadding10,
                            bottom: index == bloc.portfolio.length - 1 ? 0 : kPadding10,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(kRadius10),
                            ),
                            width: constraints.maxWidth,
                            height: constraints.maxWidth,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(kRadius10),
                              child: Image(
                                image: NetworkImage(
                                  "$kEndpoint/influencer/get-portfolio/$name?dummy=${DateTime.now().millisecondsSinceEpoch}",
                                  headers: {
                                    'Authorization': 'Bearer $kJwt',
                                  },
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ),
              ),
            if (bloc.portfolio.isEmpty) const Spacer(),
          ],
        );
      },
    );
  }
}
