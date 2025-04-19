import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/features/influencer/complete_register/bloc/complete_profile_informations/complete_profile_informations_bloc.dart';
import 'package:rociny/shared/decorations/textfield_decoration.dart';

class Department extends StatefulWidget {
  const Department({super.key});

  @override
  State<Department> createState() => _DepartmentState();
}

class _DepartmentState extends State<Department> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    CompleteProfileInformationsBloc bloc = context.read<CompleteProfileInformationsBloc>();
    controller.text = bloc.department ?? "";
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
              /// TODO translate
              "Géolocalisation",
              style: kTitle1Bold,
            ),
            const SizedBox(height: kPadding10),
            Text(
              /// TODO translate
              "Indiquez le département dans laquelle vous êtes actif.",
              style: kBody.copyWith(color: kGrey300),
            ),
            const SizedBox(height: kPadding20),
            TextField(
              controller: controller,
              decoration: kTextFieldDecoration.copyWith(
                hintText: "Département",
              ),
              style: kBody,
              onSubmitted: (value) {
                /// TODO vérifier que l'élément fait partie de la liste
                /// TODO faire auto complément (afficher sur page)
              },
            ),
            const SizedBox(height: kPadding30),
            const Spacer(),
          ],
        );
      },
    );
  }
}
