// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/influencer/settings/bloc/settings_bloc.dart';
import 'package:rociny/shared/widgets/button.dart';
import 'package:rociny/shared/widgets/fetched_instagram_account_card.dart';
import 'package:rociny/shared/widgets/instagram_account_card.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

class InstagramPage extends StatefulWidget {
  const InstagramPage({super.key});

  @override
  State<InstagramPage> createState() => _InstagramPageState();
}

class _InstagramPageState extends State<InstagramPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(kPadding20),
        child: BlocConsumer<SettingsBloc, SettingsState>(
          listener: (context, state) {
            if (state is GetFacebookSessionFailed) {
              Alert.showError(context, state.exception.message);
            }

            if (state is GetInstagramAccountsFailed) {
              Alert.showError(context, state.exception.message);
            }

            if (state is CreateInstagramAccountFailed) {
              Alert.showError(context, state.exception.message);
            }

            if (state is LogoutFacebookFailed) {
              Alert.showError(context, state.exception.message);
            }

            if (state is CreateInstagramAccountSuccess) {
              Alert.showSuccess(context, "instagram_account_added_successfully".translate());
            }

            if (state is GetFacebookSessionSuccess) {
              SettingsBloc bloc = context.read<SettingsBloc>();
              if (bloc.hasFacebookSession) {
                bloc.add(GetInstagramAccounts());
              }
            }
          },
          builder: (context, state) {
            if (state is GetFacebookSessionLoading ||
                state is GetInstagramAccountsLoading ||
                state is LogoutFacebookLoading) {
              return Center(
                  child: CircularProgressIndicator(
                color: kPrimary500,
              ));
            }

            SettingsBloc bloc = context.read<SettingsBloc>();

            // If the user has a Facebook session and Instagram account created
            if (bloc.hasFacebookSession && bloc.hasInstagramAccount) {
              return Column(
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
                        "Instagram",
                        style: kTitle1Bold,
                      ),
                      const Spacer(),
                      const SizedBox(width: kPadding20),
                    ],
                  ),
                  const SizedBox(height: kPadding30),
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
                          const Spacer(),
                          Button(
                            title: "logout".translate(),
                            backgroundColor: kRed500,
                            onPressed: () {
                              showDialog();
                            },
                          )
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
                        "Instagram",
                        style: kTitle1Bold,
                      ),
                      const Spacer(),
                      const SizedBox(width: kPadding20),
                    ],
                  ),
                  const SizedBox(height: kPadding30),
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
                          const Spacer(),
                          Button(
                              title: "logout".translate(),
                              backgroundColor: kRed500,
                              onPressed: () {
                                showDialog();
                              })
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
                      "Instagram",
                      style: kTitle1Bold,
                    ),
                    const Spacer(),
                    const SizedBox(width: kPadding20),
                  ],
                ),
                const SizedBox(height: kPadding30),
                Text("Instagram", style: kTitle1Bold),
                const SizedBox(height: kPadding10),
                Text(
                  "rociny_needs_instagram_access".translate(),
                  style: kBody.copyWith(color: kGrey300),
                ),
                const Spacer(),
                Button(
                  title: "login_button".translate(),
                  onPressed: () async {
                    await context.push('/facebook');
                    context.read<SettingsBloc>().add(GetFacebookSession());
                  },
                ),
              ],
            );
          },
        ),
      )),
    );
  }

  showDialog() {
    SettingsBloc bloc = context.read<SettingsBloc>();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(kPadding20),
              topRight: Radius.circular(kPadding20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(kPadding20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('logout'.translate(), style: kTitle1Bold),
                const SizedBox(height: kPadding10),
                Text(
                  'disconnect_facebook_warning'.translate(),
                  style: kBody.copyWith(color: kGrey300),
                ),
                const SizedBox(height: kPadding30),
                Button(
                  title: "ok".translate(),
                  backgroundColor: kRed500,
                  onPressed: () {
                    bloc.add(LogoutFacebook());
                    context.pop();
                  },
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        );
      },
    );
  }
}
