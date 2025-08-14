import 'package:rociny/core/utils/extensions/translate.dart';

class Validator {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'empty_field'.translate();
    }

    bool hasMatch = RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
        .hasMatch(value);

    if (!hasMatch) {
      return "invalid_email".translate();
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'empty_field'.translate();
    }
    if (value.length < 8) {
      return "minimum_password_length".translate();
    }

    if (value.length > 64) {
      return "maximum_password_length".translate();
    }
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return 'empty_field'.translate();
    }
    if (value.length < 3) {
      return "minimum_3_characters".translate();
    }

    return null;
  }

  static String? confirmPassword(String password, String passwordToConfirm) {
    if (passwordToConfirm.isEmpty) {
      return 'empty_field'.translate();
    }

    if (password.compareTo(passwordToConfirm) != 0) {
      return 'password_not_matching'.translate();
    }

    return null;
  }

  static String? isNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'empty_field'.translate();
    }
    return null;
  }

  static String? isMinimumLength(String? value, int min) {
    if (value == null || value.isEmpty) {
      return 'empty_field'.translate();
    }

    if (value.length < 13) {
      return "$min caractères minimum.";
    }
    return null;
  }
}
