import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/features/auth/bloc/auth/auth_bloc.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(kRadius10)),
        border: Border.all(
          color: kGrey100,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(kRadius10),
        onTap: () {
          context.read<AuthBloc>().add(OnLoginWithGoogle());
        },
        child: Center(
          child: SvgPicture.asset(
            "assets/svg/google_logo.svg",
            width: 25,
            height: 25,
          ),
        ),
      ),
    );
  }
}
