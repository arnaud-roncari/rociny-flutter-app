import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/company/search/bloc/search/search_bloc.dart';
import 'package:rociny/features/company/search/data/enums/sort_type.dart';
import 'package:rociny/features/company/search/ui/widgets/sort_card.dart';

class SortModal extends StatelessWidget {
  const SortModal({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SearchBloc>();

    return BlocConsumer<SearchBloc, SearchState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(kRadius20),
              topRight: Radius.circular(kRadius20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(kPadding20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "sort".translate(),
                  style: kTitle1Bold,
                ),
                const SizedBox(height: kPadding30),
                SortCard(
                  label: "sort_by_collaborations".translate(),
                  svg: "assets/svg/box.svg",
                  initialValue: bloc.sortType == SortType.collaborations,
                  onPressed: (_) {
                    bloc.add(SortInfluencers(sortType: SortType.collaborations));
                  },
                ),
                SortCard(
                  label: "sort_by_ratings".translate(),
                  svg: "assets/svg/star.svg",
                  initialValue: bloc.sortType == SortType.notations,
                  onPressed: (_) {
                    bloc.add(SortInfluencers(sortType: SortType.notations));
                  },
                ),
                SortCard(
                  label: "sort_by_followers".translate(),
                  svg: "assets/svg/box.svg",
                  initialValue: bloc.sortType == SortType.followers,
                  onPressed: (_) {
                    bloc.add(SortInfluencers(sortType: SortType.followers));
                  },
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        );
      },
    );
  }
}
