import 'dart:io';

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
import 'package:rociny/features/auth/data/enums/account_type.dart';
import 'package:rociny/features/auth/ui/widgets/apple_button.dart';
import 'package:rociny/features/auth/ui/widgets/google_button.dart';
import 'package:rociny/shared/decorations/textfield_decoration.dart';
import 'package:rociny/shared/widgets/button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: kWhite,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              if (state.accountType == AccountType.company) {
                context.go("/company/home");
              } else {
                context.go("/influencer/home");
              }
            }

            if (state is CompleteAccountType) {
              context.go("/complete_account_type");
            }

            if (state is LoginFailed) {
              Alert.showError(context, state.exception.message);
            }

            if (state is LoginWithGoogleFailed) {
              Alert.showError(context, state.exception.message);
            }

            if (state is LoginWithAppleFailed) {
              Alert.showError(context, state.exception.message);
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
                    ),
                    Text("login".translate(), style: kTitle1Bold),
                    const SizedBox(height: kPadding10),
                    Text(
                      "enter_email_and_password".translate(),
                      style: kBody.copyWith(color: kGrey300),
                    ),
                    const SizedBox(height: kPadding20),
                    TextFormField(
                      controller: emailController,
                      style: kBody,
                      decoration: kTextFieldDecoration.copyWith(hintText: "email".translate()),
                      validator: Validator.email,
                    ),
                    const SizedBox(height: kPadding10),
                    TextFormField(
                      controller: passwordController,
                      style: kBody,
                      obscureText: true,
                      decoration: kTextFieldDecoration.copyWith(hintText: "password".translate()),
                      validator: Validator.password,
                    ),
                    const SizedBox(height: kPadding10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          context.push('/forgot_password');
                        },
                        child: Text(
                          "forgot_password".translate(),
                          style: kCaption.copyWith(
                            color: kGrey500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: kPadding30),
                    state is LoginLoading
                        ? SizedBox(
                            height: 50,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: kPrimary500,
                              ),
                            ),
                          )
                        : Button(
                            title: "login_button".translate(),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                      OnLogin(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      ),
                                    );
                              }
                            },
                          ),
                    const SizedBox(height: kPadding30),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: kGrey100,
                          ),
                        ),
                        const SizedBox(width: kPadding15),
                        Text(
                          "or".translate(),
                          style: kBody.copyWith(color: kGrey300),
                        ),
                        const SizedBox(width: kPadding15),
                        Expanded(
                          child: Divider(
                            color: kGrey100,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: kPadding30),
                    Row(
                      children: [
                        const Expanded(child: GoogleButton()),
                        if (Platform.isIOS) const SizedBox(width: kPadding20),
                        if (Platform.isIOS) const Expanded(child: AppleButton()),
                      ],
                    ),
                    const Spacer(
                      flex: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${"no_account".translate()} ",
                          style: kBody,
                        ),
                        GestureDetector(
                          onTap: () {
                            context.push('/register');
                          },
                          child: Text(
                            "sign_up".translate(),
                            style: kBodyBold.copyWith(color: kPrimary500),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: kPadding20,
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
