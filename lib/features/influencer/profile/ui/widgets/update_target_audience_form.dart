import 'package:flutter/material.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/shared/decorations/textfield_decoration.dart';
import 'package:rociny/shared/widgets/button.dart';
import 'package:rociny/shared/widgets/chip.dart';

class UpdateTargetAudienceForm extends StatefulWidget {
  final List<String> initialValue;
  final void Function(List<String>) onUpdated;
  const UpdateTargetAudienceForm({super.key, required this.onUpdated, required this.initialValue});

  @override
  State<UpdateTargetAudienceForm> createState() => _UpdateTargetAudienceFormState();
}

class _UpdateTargetAudienceFormState extends State<UpdateTargetAudienceForm> {
  TextEditingController controller = TextEditingController();
  late List<String> targetAudience;
  List<String> fitleredTargetAudiences = kTargetAudiences;

  @override
  void initState() {
    super.initState();
    targetAudience = [...widget.initialValue];
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
                fitleredTargetAudiences =
                    kThemes.where((theme) => theme.toLowerCase().startsWith(value.toLowerCase())).toList();
              });
            } else {
              setState(() {
                fitleredTargetAudiences = kThemes;
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
                children: List.generate(fitleredTargetAudiences.length, (index) {
                  final ta = fitleredTargetAudiences[index];
                  final bool isSelected = targetAudience.contains(ta);

                  return SelectableChip(
                    onTap: () {
                      if (!isSelected && targetAudience.length < 5) {
                        setState(() {
                          targetAudience.add(ta);
                        });
                      } else {
                        setState(() {
                          targetAudience.remove(ta);
                        });
                      }
                    },
                    label: ta,
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
            widget.onUpdated(targetAudience);
          },
        ),
      ],
    );
  }
}
