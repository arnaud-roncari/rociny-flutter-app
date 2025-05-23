import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/influencer/settings/bloc/settings_bloc.dart';
import 'package:rociny/shared/widgets/button.dart';
import 'package:rociny/shared/widgets/digit_field.dart';
import 'package:rociny/shared/widgets/svg_button.dart';
import 'package:rociny/shared/widgets/time_left.dart';

class EmailCodeVerificationPage extends StatefulWidget {
  const EmailCodeVerificationPage({super.key});

  @override
  State<EmailCodeVerificationPage> createState() => _EmailCodeVerificationPageState();
}

class _EmailCodeVerificationPageState extends State<EmailCodeVerificationPage> {
  bool digitsReset = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: BlocConsumer<SettingsBloc, SettingsState>(
          listener: (context, state) {
            if (state is VerifyUpdateEmailFailed) {
              Alert.showError(context, state.exception.message);
            }

            if (state is VerifyUpdateEmailSuccess) {
              showModal();
            }
          },
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
                      context.read<SettingsBloc>().add(VerifyUpdateEmail(code: code));
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
                              "${"did_not_receive_code".translate()} ",
                              style: kBody,
                            ),
                            GestureDetector(
                              onTap: () {
                                context.read<SettingsBloc>().add(OnResentUpdateEmailVerificationCode());
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

  void showModal() {
    final bloc = context.read<SettingsBloc>();
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      backgroundColor: kWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(kRadius20)),
      ),
      builder: (context) {
        return BlocProvider.value(
          value: bloc,
          child: Padding(
            padding: const EdgeInsets.all(kPadding20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("E-mail modifié", style: kTitle1Bold),
                const SizedBox(height: kPadding10),
                Text(
                  "Vous avez modifié votre adresse email. Veuillez vous reconnecter.",
                  style: kBody.copyWith(color: kGrey300),
                ),
                const SizedBox(height: kPadding30),
                Button(
                    title: "D'accord",
                    onPressed: () {
                      context.go("/login");
                    }),
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        );
      },
    );
  }
}
