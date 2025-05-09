import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/features/auth/bloc/auth/auth_bloc.dart';
import 'package:rociny/features/auth/data/enums/account_type.dart';

import 'package:rociny/shared/widgets/button.dart';

/// TODO après apple, aider integration instagram (intégrer meta oauth)
/// un compte facenook peut avoir pluseierus comtpe isntagram (ocmment gérer le oauth)
/// NOTE : Loris must redesign this page.
class CompleteAccountTypePage extends StatelessWidget {
  const CompleteAccountTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is CompleteAccountTypeSuccess) {
              if (state.accountType == AccountType.influencer) {
                context.go('/influencer/complete_register/my_profile');
              } else {
                context.go('/company/complete_register/my_profile');
              }
            }

            if (state is CompleteAccountTypeFailed) {
              Alert.showError(context, state.exception.message);
            }
          },
          builder: (context, state) {
            if (state is CompleteAccountTypeLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: kPrimary500,
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPadding20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),

                  /// TODO translate
                  Text("Type de compte", style: kTitle1Bold),
                  const SizedBox(height: kPadding10),

                  /// TODO translate
                  Text(
                    "Définissez votre usage de Rociny.",
                    style: kBody.copyWith(color: kGrey300),
                  ),
                  const Spacer(),

                  /// TODO translate
                  Button(
                    title: "Je suis un influenceur",
                    onPressed: () {
                      context.read<AuthBloc>().add(OnCompleteAccounType(accountType: AccountType.influencer));
                    },
                  ),
                  const SizedBox(height: kPadding10),
                  Button(
                    backgroundColor: kPrimary700,
                    title: "Je suis une entreprise",
                    onPressed: () {
                      context.read<AuthBloc>().add(OnCompleteAccounType(accountType: AccountType.company));
                    },
                  ),

                  const SizedBox(
                    height: kPadding20,
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
