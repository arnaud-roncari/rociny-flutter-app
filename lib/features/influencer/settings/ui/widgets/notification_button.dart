import 'package:flutter/material.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/features/company/settings/data/contants.dart';
import 'package:rociny/features/company/settings/data/models/user_preference_model.dart';

class NotificationButton extends StatefulWidget {
  final UserNotificationPreference preference;
  final void Function(UserNotificationPreference preference, bool value) onTap;
  const NotificationButton({super.key, required this.onTap, required this.preference});

  @override
  State<NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton> {
  late bool value;

  @override
  void initState() {
    super.initState();
    value = widget.preference.enabled;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: kGrey100,
            width: 1.0,
          ),
        ),
      ),
      child: InkWell(
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          setState(() {
            value = !value;
          });

          widget.onTap(widget.preference, value);
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: kPadding20, top: kPadding15),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getTitle(widget.preference.type),
                      style: kBody,
                    ),
                    const SizedBox(height: kPadding5),
                    Text(
                      getDescription(widget.preference.type),
                      style: kCaption.copyWith(color: kGrey300),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: kPadding20),

              ///
              Container(
                width: 40,
                height: 20,
                decoration: BoxDecoration(
                  color: getColor(),
                  borderRadius: BorderRadius.circular(kRadius100),
                ),
                child: Align(
                  alignment: getAlignment(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kPadding5),
                    child: Container(
                      height: 14,
                      width: 14,
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(kRadius100),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getColor() {
    return value ? kPrimary500 : kGrey100;
  }

  AlignmentGeometry getAlignment() {
    return value ? Alignment.centerRight : Alignment.centerLeft;
  }

  String getTitle(String type) {
    return kNotifications[type]!.first;
  }

  String getDescription(String type) {
    return kNotifications[type]!.last;
  }
}
