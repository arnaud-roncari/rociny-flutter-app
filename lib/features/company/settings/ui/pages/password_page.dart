import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/core/utils/validators.dart';
import 'package:rociny/features/company/settings/bloc/settings_bloc.dart';
import 'package:rociny/shared/decorations/textfield_decoration.dart';
import 'package:rociny/shared/widgets/button.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController = TextEditingController();
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
            if (state is UpdatePasswordFailed) {
              Alert.showError(context, state.exception.message);
            }

            if (state is UpdatePasswordSuccess) {
              showModal();
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
                        "password".translate(),
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
                              "password".translate(),
                              style: kTitle1Bold,
                            ),
                            const SizedBox(height: kPadding10),
                            Text(
                              "password_cannot_be_changed_social".translate(),
                              style: kBody.copyWith(color: kGrey300),
                            ),
                          ],
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "password".translate(),
                            style: kTitle1Bold,
                          ),
                          const SizedBox(height: kPadding10),
                          Text(
                            "enter_old_and_new_password".translate(),
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
                          const SizedBox(height: kPadding20),
                          TextFormField(
                            controller: newPasswordController,
                            style: kBody,
                            obscureText: true,
                            decoration: kTextFieldDecoration.copyWith(hintText: "new_password".translate()),
                            validator: Validator.password,
                          ),
                          const SizedBox(height: kPadding10),
                          TextFormField(
                            controller: confirmNewPasswordController,
                            style: kBody,
                            obscureText: true,
                            decoration: kTextFieldDecoration.copyWith(hintText: "confirm_new_password".translate()),
                            validator: (p) => Validator.confirmPassword(p!, newPasswordController.text),
                          ),
                          const Spacer(),
                          state is UpdatePasswordLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: kPrimary500,
                                  ),
                                )
                              : Button(
                                  title: "continue".translate(),
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      context.read<SettingsBloc>().add(
                                            UpdatePassword(
                                              password: passwordController.text,
                                              newPassword: newPasswordController.text,
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
                Text("password_changed".translate(), style: kTitle1Bold),
                const SizedBox(height: kPadding10),
                Text(
                  "password_changed_message".translate(),
                  style: kBody.copyWith(color: kGrey300),
                ),
                const SizedBox(height: kPadding30),
                Button(
                    title: "ok".translate(),
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
