import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/influencer/complete_register/bloc/complete_profile_informations/complete_profile_informations_bloc.dart';
import 'package:rociny/shared/decorations/textfield_decoration.dart';
import 'package:rociny/shared/widgets/chip.dart';

class TargetAudience extends StatefulWidget {
  const TargetAudience({super.key});

  @override
  State<TargetAudience> createState() => _TargetAudienceState();
}

class _TargetAudienceState extends State<TargetAudience> {
  TextEditingController controller = TextEditingController();
  late List<String> targetAudiences;
  List<String> fitleredTargetAudiences = kTargetAudiences;

  @override
  void initState() {
    super.initState();
    CompleteProfileInformationsBloc bloc = context.read<CompleteProfileInformationsBloc>();
    targetAudiences = bloc.targetAudiences ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompleteProfileInformationsBloc, CompleteProfileInformationsState>(
      builder: (context, state) {
        CompleteProfileInformationsBloc bloc = context.read<CompleteProfileInformationsBloc>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "target".translate(),
              style: kTitle1Bold,
            ),
            const SizedBox(height: kPadding10),
            Text(
              "define_your_targets".translate(),
              style: kBody.copyWith(color: kGrey300),
            ),
            const SizedBox(height: kPadding20),
            TextField(
              controller: controller,
              decoration: kTextFieldDecoration.copyWith(
                hintText: "target".translate(),
              ),
              style: kBody,
              onChanged: (value) {
                if (value.length >= 3) {
                  setState(() {
                    fitleredTargetAudiences = kTargetAudiences
                        .where((targetAudience) => targetAudience.toLowerCase().startsWith(value.toLowerCase()))
                        .toList();
                  });
                } else {
                  setState(() {
                    fitleredTargetAudiences = kTargetAudiences;
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
                      final theme = fitleredTargetAudiences[index];
                      final bool isSelected = targetAudiences.contains(theme);

                      return SelectableChip(
                        onTap: () {
                          if (!isSelected && targetAudiences.length < 5) {
                            setState(() {
                              targetAudiences.add(theme);
                            });
                            if (targetAudiences.length == 5) {
                              bloc.add(UpdateTargetAudiences(targetAudiences: targetAudiences));
                            }
                          } else {
                            setState(() {
                              targetAudiences.remove(theme);
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
