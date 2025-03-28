import 'package:flutter/material.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/features/auth/ui/widgets/apple_button.dart';
import 'package:rociny/features/auth/ui/widgets/google_button.dart';
import 'package:rociny/shared/decorations/textfield_decoration.dart';
import 'package:rociny/shared/widgets/button.dart';

/// TODO TRANSLATE
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPadding20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text("Connexion", style: kTitle1Bold),
              Text(
                "Entrez votre email et votre mot de passe pour vous connecter.",
                style: kBody.copyWith(color: kGrey300),
              ),
              TextFormField(
                style: kBody,
                decoration: kTextFieldDecoration.copyWith(hintText: "E-mail"),
              ),
              TextFormField(
                style: kBody,
                decoration: kTextFieldDecoration.copyWith(hintText: "Mot de passe"),
              ),
              const SizedBox(height: kPadding5),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    // Redirect to forgot password
                  },
                  child: Text(
                    "Mot de passe oublié ?",
                    style: kCaption.copyWith(
                      color: kGrey500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: kPadding30),
              Button(
                  title: "Se connecter",
                  onPressed: () {
                    /// Login emit
                  }),
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
                    "Ou",
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
              const Row(
                children: [
                  Expanded(child: GoogleButton()),
                  SizedBox(width: kPadding20),
                  Expanded(child: AppleButton()),
                ],
              ),
              const Spacer(
                flex: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Je n'ai pas de compte ? ",
                    style: kBody,
                  ),
                  GestureDetector(
                    onTap: () {
                      // Redirect to sign-up page
                    },
                    child: Text(
                      "S'inscrire",
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
      ),
    );
  }
}
