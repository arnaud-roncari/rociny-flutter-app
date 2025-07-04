import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/features/company/search/bloc/search_bloc.dart';

/// TODO si pas de theme choisi, apres le get, mélanger les resultats
/// TODO pouvoir refresh
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<SearchBloc, SearchState>(
      listener: (context, state) {
        if (state is GetInfluencersByThemeFailed) {
          Alert.showError(context, state.exception.message);
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: kPadding20),
            buildSearchButton(),
            const SizedBox(height: kPadding20),
            buildThemes(),
            const SizedBox(height: kPadding20),
          ],
        );
      },
    );
  }

  Widget buildSearchButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPadding20),
      child: Container(
        height: 40,
        width: double.infinity,
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(kRadius100),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: kBlack.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(kRadius100),
            onTap: () {
              /// TODO
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPadding15),
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/svg/loop.svg",
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(kGrey300, BlendMode.srcIn),
                  ),
                  const SizedBox(width: kPadding15),
                  Text(
                    "Trouve ton influenceur",
                    style: kBody.copyWith(color: kGrey300),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildThemes() {
    final bloc = context.read<SearchBloc>();
    List<Widget> themes = [];

    for (String theme in kThemes) {
      bool isSelected = theme == bloc.theme;
      themes.add(
        Padding(
          padding: const EdgeInsets.only(right: kPadding10),
          child: Container(
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kRadius100),
              border: isSelected
                  ? null
                  : Border.all(
                      color: kGrey100,
                      width: 0.5,
                    ),
              color: isSelected ? kPrimary500 : kWhite,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(kRadius100),
                onTap: () {
                  bloc.add(GetInfluencersByTheme(theme: theme));
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kPadding20),
                    child: Text(
                      theme,
                      style: isSelected ? kCaptionBold.copyWith(color: kWhite) : kCaption.copyWith(color: kBlack),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 30,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          const SizedBox(width: kPadding20),
          ...themes,
          const SizedBox(width: kPadding10),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
