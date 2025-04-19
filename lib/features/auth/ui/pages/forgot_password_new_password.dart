import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/core/utils/validators.dart';
import 'package:rociny/features/auth/bloc/auth/auth_bloc.dart';
import 'package:rociny/features/auth/ui/widgets/password_changed_modal.dart';
import 'package:rociny/shared/decorations/textfield_decoration.dart';
import 'package:rociny/shared/widgets/button.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

/// TODO faire création remplissage profil pour influencer et entreprise
class ForgotPasswordNewPasswordPage extends StatefulWidget {
  const ForgotPasswordNewPasswordPage({super.key});

  @override
  State<ForgotPasswordNewPasswordPage> createState() => _ForgotPasswordNewPasswordPageState();
}

class _ForgotPasswordNewPasswordPageState extends State<ForgotPasswordNewPasswordPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    passwordController.text = "newpassword1";
    confirmPasswordController.text = "newpassword1";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
          child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ForgotPasswordVerificationFailed) {
            Alert.showError(context, state.exception.message);
          }

          if (state is ForgotPasswordVerificationSuccess) {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return const PasswordChangedModal();
              },
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPadding20),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: SvgButton(
                        path: "assets/svg/left_arrow.svg",
                        color: kBlack,
                        onPressed: () {
                          context.pop();
                        },
                      ),
                    ),
                  ),
                  Text("new_password".translate(), style: kTitle1Bold),
                  const SizedBox(height: kPadding10),
                  Text(
                    "new_password_requirements".translate(),
                    style: kBody.copyWith(color: kGrey300),
                  ),
                  const SizedBox(height: kPadding20),
                  TextFormField(
                    controller: passwordController,
                    decoration: kTextFieldDecoration.copyWith(hintText: "password".translate()),
                    validator: Validator.password,
                    style: kBody,
                  ),
                  const SizedBox(height: kPadding20),
                  TextFormField(
                    controller: confirmPasswordController,
                    style: kBody,
                    decoration: kTextFieldDecoration.copyWith(hintText: "confirm_password".translate()),
                    validator: (_) => Validator.confirmPassword(
                      passwordController.text,
                      confirmPasswordController.text,
                    ),
                  ),
                  const SizedBox(height: kPadding30),
                  state is ForgotPasswordVerificationLoading
                      ? SizedBox(
                          height: 50,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: kPrimary500,
                            ),
                          ),
                        )
                      : Button(
                          title: "change".translate(),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                    OnNewPasswordEntered(password: passwordController.text),
                                  );
                            }
                          },
                        ),
                ],
              ),
            ),
          );
        },
      )),
    );
  }
}
