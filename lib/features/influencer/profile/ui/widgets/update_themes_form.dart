import 'package:flutter/material.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/shared/decorations/textfield_decoration.dart';
import 'package:rociny/shared/widgets/button.dart';
import 'package:rociny/shared/widgets/chip.dart';

class UpdateThemesForm extends StatefulWidget {
  final List<String> initialValue;
  final void Function(List<String>) onUpdated;
  const UpdateThemesForm({super.key, required this.onUpdated, required this.initialValue});

  @override
  State<UpdateThemesForm> createState() => _UpdateThemesFormState();
}

class _UpdateThemesFormState extends State<UpdateThemesForm> {
  TextEditingController controller = TextEditingController();
  late List<String> themes;
  List<String> fitleredThemes = kThemes;

  @override
  void initState() {
    super.initState();
    themes = [...widget.initialValue];
  }

  @override
  Widget build(BuildContext context) {
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
                    kThemes.where((theme) => theme.translate().toLowerCase().startsWith(value.toLowerCase())).toList();
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
                      if (!isSelected && themes.length < 3) {
                        setState(() {
                          themes.add(theme);
                        });
                      } else {
                        setState(() {
                          themes.remove(theme);
                        });
                      }
                    },
                    label: theme.translate(),
                    isSelected: isSelected,
                  );
                }),
              ),
            ),
          ),
        ),
        Button(
          title: "change".translate(),
          onPressed: () {
            widget.onUpdated(themes);
          },
        ),
      ],
    );
  }
}
