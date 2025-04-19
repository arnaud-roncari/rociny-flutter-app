import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/core/utils/validators.dart';
import 'package:rociny/features/auth/bloc/auth/auth_bloc.dart';
import 'package:rociny/features/auth/data/enums/account_type.dart';
import 'package:rociny/shared/decorations/textfield_decoration.dart';
import 'package:rociny/shared/widgets/button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  AccountType accountType = AccountType.influencer;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    emailController.text = "new-user@rociny.com";
    passwordController.text = "yourpassword";
    confirmPasswordController.text = "yourpassword";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is RegisterFailed) {
              Alert.showError(context, state.exception.message);
            }

            if (state is RegisterSuccess) {
              context.push(
                "/register/code_verification",
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
                    ),
                    Text("registration".translate(), style: kTitle1Bold),
                    const SizedBox(height: kPadding10),
                    Row(
                      children: [
                        Text(
                          accountType == AccountType.influencer
                              ? "${"am_i_a_company".translate()} "
                              : "${"am_i_a_influencer".translate()} ",
                          style: kBody.copyWith(color: kGrey300),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (accountType == AccountType.influencer) {
                                accountType = AccountType.company;
                              } else {
                                accountType = AccountType.influencer;
                              }
                            });
                          },
                          child: Text(
                            accountType == AccountType.influencer
                                ? "${"create_company_account".translate()} "
                                : "${"create_influencer_account".translate()} ",
                            style: kBodyBold.copyWith(color: kPrimary500),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: kPadding20),
                    TextFormField(
                      controller: emailController,
                      style: kBody,
                      decoration: kTextFieldDecoration.copyWith(hintText: "email".translate()),
                      validator: Validator.email,
                    ),
                    const SizedBox(height: kPadding20),
                    TextFormField(
                      controller: passwordController,
                      style: kBody,
                      obscureText: true,
                      decoration: kTextFieldDecoration.copyWith(hintText: "password".translate()),
                      validator: Validator.password,
                    ),
                    const SizedBox(height: kPadding10),
                    TextFormField(
                      controller: confirmPasswordController,
                      style: kBody,
                      obscureText: true,
                      decoration: kTextFieldDecoration.copyWith(hintText: "confirm_password".translate()),
                      validator: (passwordToConfirm) =>
                          Validator.confirmPassword(passwordController.text, passwordToConfirm!),
                    ),
                    const SizedBox(height: kPadding30),
                    state is RegisterLoading
                        ? SizedBox(
                            height: 50,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: kPrimary500,
                              ),
                            ),
                          )
                        : Button(
                            title: "sign_up_button".translate(),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                      OnRegister(
                                        email: emailController.text,
                                        password: passwordController.text,
                                        accountType: accountType,
                                      ),
                                    );
                              }
                            }),
                    const SizedBox(height: kPadding10),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "${"by_signing_up_you_accept".translate()} ",
                        style: kCaption.copyWith(color: kGrey300),
                        children: [
                          TextSpan(
                            text: "terms_of_service".translate(),
                            style: kCaption.copyWith(color: kPrimary500),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.push("/preview_pdf", extra: "$kEndpoint/policy/terms-of-use");
                              },
                          ),
                          TextSpan(
                            text: " ${"of_this_service_and_acknowledge".translate()} ",
                            style: kCaption.copyWith(color: kGrey300),
                          ),
                          TextSpan(
                            text: "privacy_policy".translate(),
                            style: kCaption.copyWith(color: kPrimary500),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.push("/preview_pdf", extra: "$kEndpoint/policy/privacy-policy");
                              },
                          ),
                        ],
                      ),
                    ),
                    const Spacer(
                      flex: 3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${"i_have_an_account".translate()} ",
                          style: kBody,
                        ),
                        GestureDetector(
                          onTap: () {
                            context.pop();
                          },
                          child: Text(
                            "log_in".translate(),
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
