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
import 'package:rociny/shared/decorations/textfield_decoration.dart';
import 'package:rociny/shared/widgets/button.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController.text = "arnaud.roncaripro@gmail.com";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kWhite,
      body: SafeArea(
          child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ForgotPasswordFailed) {
            Alert.showError(context, state.exception.message);
          }
          if (state is ForgotPasswordSuccess) {
            context.push(
              "/forgot_password/code_verification",
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
                  Text("forgot_password_title".translate(), style: kTitle1Bold),
                  const SizedBox(height: kPadding10),
                  Text(
                    "forgot_password_instructions".translate(),
                    style: kBody.copyWith(color: kGrey300),
                  ),
                  const SizedBox(height: kPadding20),
                  TextFormField(
                    controller: emailController,
                    style: kBody,
                    decoration: kTextFieldDecoration.copyWith(hintText: "email".translate()),
                    validator: Validator.email,
                  ),
                  const SizedBox(height: kPadding30),
                  state is ForgotPasswordLoading
                      ? SizedBox(
                          height: 50,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: kPrimary500,
                            ),
                          ),
                        )
                      : Button(
                          title: "receive_code".translate(),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                    OnForgotPassword(email: emailController.text),
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
