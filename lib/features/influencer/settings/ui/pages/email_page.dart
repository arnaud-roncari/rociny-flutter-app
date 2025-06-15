import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/core/utils/validators.dart';
import 'package:rociny/features/influencer/settings/bloc/settings_bloc.dart';
import 'package:rociny/shared/decorations/textfield_decoration.dart';
import 'package:rociny/shared/widgets/button.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    final bloc = context.read<SettingsBloc>();
    if (bloc.isRegisteredLocally == null) {
      bloc.add(GetIsRegisteredLocally());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(kPadding20),
        child: BlocConsumer<SettingsBloc, SettingsState>(
          listener: (context, state) {
            if (state is GetIsRegisteredLocallyFailed) {
              Alert.showError(context, state.exception.message);
            }
            if (state is UpdateEmailFailed) {
              Alert.showError(context, state.exception.message);
            }
            if (state is UpdateEmailSuccess) {
              context.push("/influencer/home/settings/credentials/email/code-verification");
            }
          },
          builder: (context, state) {
            final bloc = context.read<SettingsBloc>();

            if (state is GetIsRegisteredLocallyLoading || bloc.isRegisteredLocally == null) {
              return Center(
                child: CircularProgressIndicator(
                  color: kPrimary500,
                ),
              );
            }

            return Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgButton(
                        path: "assets/svg/left_arrow.svg",
                        color: kBlack,
                        onPressed: () {
                          context.pop();
                        },
                      ),
                      const Spacer(),
                      Text(
                        "email_address".translate(),
                        style: kTitle1Bold,
                      ),
                      const Spacer(),
                      const SizedBox(width: kPadding20),
                    ],
                  ),
                  const SizedBox(height: kPadding30),
                  Expanded(
                    child: Builder(builder: (_) {
                      if (!bloc.isRegisteredLocally!) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "email".translate(),
                              style: kTitle1Bold,
                            ),
                            const SizedBox(height: kPadding10),
                            Text(
                              "email_cannot_be_changed_social".translate(),
                              style: kBody.copyWith(color: kGrey300),
                            ),
                          ],
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "email".translate(),
                            style: kTitle1Bold,
                          ),
                          const SizedBox(height: kPadding10),
                          Text(
                            "enter_password_and_new_email".translate(),
                            style: kBody.copyWith(color: kGrey300),
                          ),
                          const SizedBox(height: kPadding20),
                          TextFormField(
                            controller: passwordController,
                            style: kBody,
                            decoration: kTextFieldDecoration.copyWith(hintText: "password".translate()),
                            obscureText: true,
                            validator: Validator.isNotEmpty,
                          ),
                          const SizedBox(height: kPadding10),
                          TextFormField(
                            controller: emailController,
                            style: kBody,
                            decoration: kTextFieldDecoration.copyWith(hintText: "new_email".translate()),
                            validator: Validator.email,
                          ),
                          const Spacer(),
                          Button(
                            title: "continue".translate(),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<SettingsBloc>().add(
                                      UpdateEmail(
                                        newEmail: emailController.text,
                                        password: passwordController.text,
                                      ),
                                    );
                              }
                            },
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        ),
      )),
    );
  }
}
