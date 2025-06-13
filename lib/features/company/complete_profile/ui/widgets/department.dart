import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/company/complete_profile/bloc/complete_profile/complete_profile_bloc.dart';
import 'package:rociny/shared/decorations/textfield_decoration.dart';
import 'package:rociny/shared/widgets/chip.dart';

class Department extends StatefulWidget {
  const Department({super.key});

  @override
  State<Department> createState() => _DepartmentState();
}

class _DepartmentState extends State<Department> {
  TextEditingController controller = TextEditingController();
  List<String> fitleredDepartments = kDepartments;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompleteProfileBloc, CompleteProfileState>(
      builder: (context, state) {
        CompleteProfileBloc bloc = context.read<CompleteProfileBloc>();

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
                      final bool isSelected = bloc.department == department;

                      return SelectableChip(
                        onTap: () {
                          bloc.add(UpdateDepartment(department: department));
                        },
                        label: department,
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
