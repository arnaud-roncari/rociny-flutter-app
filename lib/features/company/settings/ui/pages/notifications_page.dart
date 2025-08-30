import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/core/utils/extensions/translate.dart';
import 'package:rociny/features/company/settings/bloc/settings_bloc.dart';
import 'package:rociny/features/company/settings/data/models/user_preference_model.dart';
import 'package:rociny/features/influencer/settings/ui/widgets/notification_button.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(kPadding20),
        child: BlocConsumer<SettingsBloc, SettingsState>(
          listener: (context, state) {
            if (state is GetNotificationPreferencesFailed) {
              Alert.showError(context, state.exception.message);
            }

            if (state is UpdateNotificationPreferenceFailed) {
              Alert.showError(context, state.exception.message);
            }
          },
          builder: (context, state) {
            if (state is GetNotificationPreferencesLoading || state is GetNotificationPreferencesFailed) {
              return Center(
                child: CircularProgressIndicator(
                  color: kPrimary500,
                ),
              );
            }

            var bloc = context.read<SettingsBloc>();

            return SingleChildScrollView(
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
                        "notifications".translate(),
                        style: kTitle1Bold,
                      ),
                      const Spacer(),
                      const SizedBox(width: kPadding20),
                    ],
                  ),
                  const SizedBox(height: kPadding30),
                  NotificationButton(
                    preference: getPreference("new_message"),
                    onTap: (p, enabled) {
                      bloc.add(UpdateNotificationPreference(
                        type: p.type,
                        enabled: enabled,
                      ));
                    },
                  ),
                  const SizedBox(height: kPadding5),
                  NotificationButton(
                    preference: getPreference("new_review"),
                    onTap: (p, enabled) {
                      bloc.add(UpdateNotificationPreference(
                        type: p.type,
                        enabled: enabled,
                      ));
                    },
                  ),
                  const SizedBox(height: kPadding5),
                  NotificationButton(
                    preference: getPreference("collaboration_refused_by_influencer"),
                    onTap: (p, enabled) {
                      bloc.add(UpdateNotificationPreference(
                        type: p.type,
                        enabled: enabled,
                      ));
                    },
                  ),
                  const SizedBox(height: kPadding5),
                  NotificationButton(
                    preference: getPreference("collaboration_waiting_for_company_payment"),
                    onTap: (p, enabled) {
                      bloc.add(UpdateNotificationPreference(
                        type: p.type,
                        enabled: enabled,
                      ));
                    },
                  ),
                  const SizedBox(height: kPadding5),
                  NotificationButton(
                    preference: getPreference("collaboration_in_progress"),
                    onTap: (p, enabled) {
                      bloc.add(UpdateNotificationPreference(
                        type: p.type,
                        enabled: enabled,
                      ));
                    },
                  ),
                  const SizedBox(height: kPadding5),
                  NotificationButton(
                    preference: getPreference("collaboration_pending_company_validation"),
                    onTap: (p, enabled) {
                      bloc.add(UpdateNotificationPreference(
                        type: p.type,
                        enabled: enabled,
                      ));
                    },
                  ),
                  const SizedBox(height: kPadding5),
                  NotificationButton(
                    preference: getPreference("collaboration_done"),
                    onTap: (p, enabled) {
                      bloc.add(UpdateNotificationPreference(
                        type: p.type,
                        enabled: enabled,
                      ));
                    },
                  ),
                  const SizedBox(height: kPadding5),
                ],
              ),
            );
          },
        ),
      )),
    );
  }

  UserNotificationPreference getPreference(String type) {
    List<UserNotificationPreference> notifications = context.read<SettingsBloc>().notifications;

    for (UserNotificationPreference n in notifications) {
      if (n.type == type) {
        return n;
      }
    }

    throw Exception("Not found");
  }
}
