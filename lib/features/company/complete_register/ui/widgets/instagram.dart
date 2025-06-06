import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/company/complete_register/bloc/complete_company_profile_informations/complete_company_profile_informations_bloc.dart';
import 'package:rociny/shared/widgets/button.dart';
import 'package:rociny/shared/widgets/fetched_instagram_account_card.dart';
import 'package:rociny/shared/widgets/instagram_account_card.dart';

class Instagram extends StatefulWidget {
  const Instagram({super.key});

  @override
  State<Instagram> createState() => _InstagramState();
}

class _InstagramState extends State<Instagram> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompleteCompanyProfileInformationsBloc, CompleteCompanyProfileInformationsState>(
      builder: (context, state) {
        if (state is GetFacebookSessionLoading || state is GetInstagramAccountsLoading) {
          return Center(
              child: CircularProgressIndicator(
            color: kPrimary500,
          ));
        }

        final bloc = context.read<CompleteCompanyProfileInformationsBloc>();
        // If the user has a Facebook session and Instagram account created
        if (bloc.hasFacebookSession && bloc.hasInstagramAccount) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Instagram", style: kTitle1Bold),
              const SizedBox(height: kPadding10),
              Text(
                "connected_to_facebook_with_instagram".translate(),
                style: kBody.copyWith(color: kGrey300),
              ),
              const SizedBox(height: kPadding30),
              Expanded(
                child: Builder(builder: (context) {
                  return Column(
                    children: [
                      if (bloc.instagramAccounts.isEmpty)
                        Text(
                          "no_instagram_account_found".translate(),
                          style: kBody.copyWith(color: kGrey300),
                        ),
                      InstagramAccountCard(
                        instagramAccount: bloc.instagramAccount!,
                      ),
                    ],
                  );
                }),
              ),
            ],
          );
        }

        // If the user has a Facebook session, show the Instagram selection
        if (bloc.hasFacebookSession) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Instagram", style: kTitle1Bold),
              const SizedBox(height: kPadding10),
              Text(
                "connected_to_facebook_select_instagram".translate(),
                style: kBody.copyWith(color: kGrey300),
              ),
              const SizedBox(height: kPadding30),
              Expanded(
                child: Builder(builder: (context) {
                  if (state is CreateInstagramAccountLoading) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: kPrimary500,
                    ));
                  }

                  return Column(
                    children: [
                      if (bloc.instagramAccounts.isEmpty)
                        Text(
                          "rociny_needs_instagram_access".translate(),
                          style: kBody.copyWith(color: kGrey300),
                        ),
                      ...bloc.instagramAccounts.map(
                        (ia) => Padding(
                          padding: const EdgeInsets.only(bottom: kPadding10),
                          child: FetchedInstagramAccountCard(
                            instagramAccount: ia,
                            onTap: (ia) {
                              bloc.add(CreateInstagramAccount(fetchedInstagramAccountId: ia.id));
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          );
        }

        // Not connected to Facebook
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: kPadding30),
            Text("Instagram", style: kTitle1Bold),
            const SizedBox(height: kPadding10),
            Text(
              "rociny_needs_instagram_access".translate(),
              style: kBody.copyWith(color: kGrey300),
            ),
            const Spacer(),
            Button(
              backgroundColor: kBlack,
              title: "login_button".translate(),
              onPressed: () async {
                await context.push('/facebook');
                bloc.add(GetFacebookSession());
              },
            ),
            const SizedBox(height: kPadding10),
          ],
        );
      },
    );
  }
}
