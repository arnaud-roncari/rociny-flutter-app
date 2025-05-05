import 'package:flutter/material.dart';
import 'package:rociny/core/constants/colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: const SafeArea(child: Placeholder()),
    );
  }
}
