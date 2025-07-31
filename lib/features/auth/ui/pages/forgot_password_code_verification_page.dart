import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/auth/bloc/auth/auth_bloc.dart';
import 'package:rociny/shared/widgets/digit_field.dart';
import 'package:rociny/shared/widgets/svg_button.dart';
import 'package:rociny/shared/widgets/time_left.dart';

class ForgotPasswordCodeVerificationPage extends StatefulWidget {
  const ForgotPasswordCodeVerificationPage({super.key});

  @override
  State<ForgotPasswordCodeVerificationPage> createState() => _ForgotPasswordCodeVerificationPageState();
}

class _ForgotPasswordCodeVerificationPageState extends State<ForgotPasswordCodeVerificationPage> {
  bool digitsReset = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kWhite,
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(kPadding20),
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
                  Text("verification".translate(), style: kTitle1Bold),
                  const SizedBox(height: kPadding10),
                  Text(
                    "verification_message".translate(),
                    style: kBody.copyWith(color: kGrey300),
                  ),
                  const SizedBox(height: kPadding20),
                  DigitField(
                    onCodeEntered: (code) {
                      context.read<AuthBloc>().add(OnCodeEnteredForgotPassword(code: code));
                      context.push("/forgot_password/new_password");
                    },
                  ),
                  const SizedBox(height: kPadding10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: kPadding10),
                      child: TimeLeft(
                        onComplete: () {
                          context.pop();
                        },
                      ),
                    ),
                  ),
                  const Spacer(),
                  digitsReset
                      ? Center(
                          child: Text(
                            "code_resent".translate(),
                            style: kBodyBold.copyWith(color: kGreen500),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "did_not_receive_code".translate(),
                              style: kBody,
                            ),
                            GestureDetector(
                              onTap: () {
                                context.read<AuthBloc>().add(OnResentForgotPasswordVerificationCode());
                                if (!digitsReset) {
                                  setState(() {
                                    digitsReset = true;
                                  });
                                }
                              },
                              child: Text(
                                "resend_code".translate(),
                                style: kBodyBold.copyWith(color: kPrimary500),
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: kPadding20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
