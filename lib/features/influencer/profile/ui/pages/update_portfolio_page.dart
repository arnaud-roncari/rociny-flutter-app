import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/extensions/translate.dart';

import 'package:rociny/features/influencer/profile/bloc/profile_bloc.dart';
import 'package:rociny/features/influencer/profile/ui/widgets/update_portfolio_form.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

class UpdatePorfolioPage extends StatelessWidget {
  const UpdatePorfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ProfileBloc>();
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(kPadding20),
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is UpdatePortfolioFailed) {
              Alert.showError(context, state.exception.message);
            }
          },
          builder: (context, state) {
            if (state is UpdatePortfolioLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: kPrimary500,
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    const Spacer(),
                    Text(
                      "change".translate(),
                      style: kTitle1Bold,
                    ),
                    const SizedBox(width: kPadding20),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: kPadding30),
                Expanded(
                  child: UpdatePortfolioForm(
                    initialValue: bloc.influencer.portfolio,
                    onAdded: () => bloc.add(AddPicturesToPortfolio()),
                    onRemoved: (pictureUrl) => bloc.add(RemovePictureFromPortfolio(pictureUrl: pictureUrl)),
                  ),
                ),
              ],
            );
          },
        ),
      )),
    );
  }
}
