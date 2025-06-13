import 'package:flutter/material.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/shared/decorations/textfield_decoration.dart';
import 'package:rociny/shared/widgets/button.dart';
import 'package:rociny/shared/widgets/chip.dart';

class UpdateGeolocationForm extends StatefulWidget {
  final String? initialValue;
  final void Function(String) onUpdated;
  const UpdateGeolocationForm({super.key, required this.onUpdated, required this.initialValue});

  @override
  State<UpdateGeolocationForm> createState() => _UpdateGeolocationFormState();
}

class _UpdateGeolocationFormState extends State<UpdateGeolocationForm> {
  TextEditingController controller = TextEditingController();
  List<String> fitleredDepartments = kDepartments;
  String? selectedDepartment;

  @override
  void initState() {
    selectedDepartment = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "geolocation".translate(),
          style: kTitle1Bold,
        ),
        const SizedBox(height: kPadding10),
        Text(
          "indicate_active_department".translate(),
          style: kBody.copyWith(color: kGrey300),
        ),
        const SizedBox(height: kPadding20),
        TextField(
          controller: controller,
          decoration: kTextFieldDecoration.copyWith(
            hintText: "department".translate(),
          ),
          style: kBody,
          onChanged: (value) {
            if (value.length >= 3) {
              setState(() {
                fitleredDepartments = kDepartments
                    .where((department) => department.toLowerCase().startsWith(value.toLowerCase()))
                    .toList();
              });
            } else {
              setState(() {
                fitleredDepartments = kDepartments;
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
                children: List.generate(fitleredDepartments.length, (index) {
                  final department = fitleredDepartments[index];
                  final bool isSelected = selectedDepartment == department;

                  return SelectableChip(
                    onTap: () {
                      setState(() {
                        selectedDepartment = department;
                      });
                    },
                    label: department,
                    isSelected: isSelected,
                  );
                }),
              ),
            ),
          ),
        ),
        Button(
          title: "Modifier",
          onPressed: () {
            if (selectedDepartment != null) {
              widget.onUpdated(selectedDepartment!);
            }
          },
        )
      ],
    );
  }
}
