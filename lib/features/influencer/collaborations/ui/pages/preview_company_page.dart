import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/features/company/profile/ui/widgets/company_profile.dart';
import 'package:rociny/features/influencer/collaborations/bloc/preview_bloc.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

class PreviewCompanyPage extends StatefulWidget {
  final int userId;
  const PreviewCompanyPage({super.key, required this.userId});

  @override
  State<PreviewCompanyPage> createState() => _PreviewCompanyPageState();
}

class _PreviewCompanyPageState extends State<PreviewCompanyPage> {
  @override
  void initState() {
    super.initState();
    context.read<PreviewBloc>().add(Initialize(userId: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: BlocConsumer<PreviewBloc, PreviewState>(
          listener: (context, state) {
            if (state is InitializeFailed) {
              Alert.showError(context, state.exception.message);
            }
          },
          builder: (context, state) {
            final bloc = context.read<PreviewBloc>();

            if (state is InitializeLoading || state is InitializeFailed) {
              return Center(
                child: CircularProgressIndicator(color: kPrimary500),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPadding20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: kPadding20),
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
                      Text("Entreprise", style: kTitle1Bold),
                      const Spacer(),
                      const SizedBox(width: kPadding20),
                    ],
                  ),
                  const SizedBox(height: kPadding15),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: kPadding15),
                          CompanyProfile(
                            company: bloc.company,
                            instagramAccount: bloc.instagramAccount,
                          ),
                          const SizedBox(height: kPadding20),
                        ],
                      ),
                    ),
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
