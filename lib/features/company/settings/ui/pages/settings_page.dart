import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/config/environment.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/company/settings/bloc/settings_bloc.dart';
import 'package:rociny/features/influencer/settings/ui/widgets/navigation_button.dart';
import 'package:rociny/shared/widgets/button.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(kPadding20),
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
                  "settings".translate(),
                  style: kTitle1Bold,
                ),
                const Spacer(),
                const SizedBox(width: kPadding20),
              ],
            ),
            const SizedBox(height: kPadding30),
            NavigationButton(
              svgPath: "assets/svg/people.svg",
              label: "login_information".translate(),
              onPressed: () {
                context.push("/company/home/settings/credentials");
              },
            ),
            const SizedBox(height: kPadding5),
            NavigationButton(
              svgPath: "assets/svg/suitcase.svg",
              label: "my_company".translate(),
              onPressed: () {
                context.read<SettingsBloc>().add(GetCompanySectionsStatus());
                context.push("/company/home/settings/company");
              },
            ),
            const SizedBox(height: kPadding5),
            NavigationButton(
              svgPath: "assets/svg/bell.svg",
              label: "notifications".translate(),
              onPressed: () {
                context.read<SettingsBloc>().add(GetNotificationPreferences());
                context.push("/company/home/settings/notifications");
              },
            ),
            // const SizedBox(height: kPadding5),
            // NavigationButton(
            //   svgPath: "assets/svg/file.svg",
            //   label: "legal_documents".translate(),
            //   onPressed: () {
            //     context.push("/company/home/settings/policies");
            //   },
            // ),
            const SizedBox(height: kPadding5),
            NavigationButton(
              svgPath: "assets/svg/logout.svg",
              label: "logout".translate(),
              onPressed: () {
                showLogoutModal(context);
              },
            ),
            const SizedBox(height: kPadding5),
            NavigationButton(
              svgPath: "assets/svg/trash.svg",
              label: "delete_account".translate(),
              onPressed: () {
                showDeleteAccountModal(context);
              },
            ),
            const SizedBox(height: kPadding20),
            Text(
              "Rociny",
              style: kTitle1Bold.copyWith(color: kGrey200),
            ),
            const SizedBox(height: kPadding5),
            Text(
              "Version $kAppVersion",
              style: kBody.copyWith(color: kGrey200),
            ),
          ],
        ),
      )),
    );
  }

  void showLogoutModal(BuildContext context) {
    final bloc = context.read<SettingsBloc>();
    showModalBottomSheet(
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
                Text("logout".translate(), style: kTitle1Bold),
                const SizedBox(height: kPadding10),
                Text(
                  "confirm_logout_message".translate(),
                  style: kBody.copyWith(color: kGrey300),
                ),
                const SizedBox(height: kPadding30),
                Button(
                    title: "ok".translate(),
                    onPressed: () {
                      bloc.add(OnLogout());
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

  void showDeleteAccountModal(BuildContext context) {
    final bloc = context.read<SettingsBloc>();
    showModalBottomSheet(
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
                Text("confirm_delete".translate(), style: kTitle1Bold),
                const SizedBox(height: kPadding10),
                Text(
                  "confirm_delete_message".translate(),
                  style: kBody.copyWith(color: kGrey300),
                ),
                const SizedBox(height: kPadding30),
                Button(
                    title: "ok".translate(),
                    onPressed: () {
                      bloc.add(OnDeleteAccount());
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
