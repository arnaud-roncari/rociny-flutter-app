import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/influencer/complete_register/bloc/complete_influencer_profile_informations/complete_influencer_profile_informations_bloc.dart';
import 'package:rociny/shared/decorations/textfield_decoration.dart';
import 'package:rociny/shared/widgets/chip.dart';

class Themes extends StatefulWidget {
  const Themes({super.key});

  @override
  State<Themes> createState() => _ThemesState();
}

class _ThemesState extends State<Themes> {
  TextEditingController controller = TextEditingController();
  late List<String> themes;
  List<String> fitleredThemes = kThemes;

  @override
  void initState() {
    super.initState();
    CompleteInfluencerProfileInformationsBloc bloc = context.read<CompleteInfluencerProfileInformationsBloc>();
    themes = bloc.themes ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompleteInfluencerProfileInformationsBloc, CompleteInfluencerProfileInformationsState>(
      builder: (context, state) {
        CompleteInfluencerProfileInformationsBloc bloc = context.read<CompleteInfluencerProfileInformationsBloc>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "themes".translate(),
              style: kTitle1Bold,
            ),
            const SizedBox(height: kPadding10),
            Text(
              "define_themes_description".translate(),
              style: kBody.copyWith(color: kGrey300),
            ),
            const SizedBox(height: kPadding20),
            TextField(
              controller: controller,
              decoration: kTextFieldDecoration.copyWith(
                hintText: "theme".translate(),
              ),
              style: kBody,
              onChanged: (value) {
                if (value.length >= 3) {
                  setState(() {
                    fitleredThemes =
                        kThemes.where((theme) => theme.toLowerCase().startsWith(value.toLowerCase())).toList();
                  });
                } else {
                  setState(() {
                    fitleredThemes = kThemes;
                  });
                }
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: kPadding30),
                  child: Wrap(
                    spacing: kPadding10,
                    runSpacing: kPadding10,
                    children: List.generate(fitleredThemes.length, (index) {
                      final theme = fitleredThemes[index];
                      final bool isSelected = themes.contains(theme);

                      return SelectableChip(
                        onTap: () {
                          if (!isSelected && themes.length < 5) {
                            setState(() {
                              themes.add(theme);
                            });
                            if (themes.length == 5) {
                              bloc.add(UpdateThemes(themes: themes));
                            }
                          } else {
                            setState(() {
                              themes.remove(theme);
                            });
                          }
                        },
                        label: theme,
                        isSelected: isSelected,
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
