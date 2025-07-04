import 'package:flutter/material.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/api_exception.dart';
import 'package:rociny/core/utils/extensions/translate.dart';

class Alert {
  static showError(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(color: kRed700, borderRadius: BorderRadius.circular(kRadius10)),
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: kBody.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  static showSuccess(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(color: kPrimary700, borderRadius: BorderRadius.circular(kRadius10)),
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: kBody.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class AlertException {
  final String message;

  AlertException({required this.message});

  factory AlertException.fromException(Object exception) {
    String message = "Oups... Une erreur est survenue.";

    if (exception is ApiException) {
      switch (exception.id) {
        case "security:user:not_found":
          message = "email_or_password_incorrect".translate();
          break;
        case "security:password:not_matching":
          message = "email_or_password_incorrect".translate();
          break;
        case "security:user:already_registering":
          message = "user_already_registering".translate();
          break;
        case "security:user:already_exist":
          message = "user_already_exists".translate();
          break;
        case "security:code:not_matching":
          message = "code_incorrect".translate();
          break;
        case "security:user:file_required":
          message = "file_required".translate();
          break;
        case "security:social_network:already_exist":
          message = "social_network_already_exists".translate();
          break;
        case "security:legal_document:already_exist":
          message = "legal_document_already_exists".translate();
          break;
        case "security:instagram:not_found":
          message = "instagram_not_found".translate();
          break;
        case "security:instagram:already_exist":
          message = "instagram_already_exists".translate();
          break;
      }
    }

    return AlertException(message: message);
  }
}
