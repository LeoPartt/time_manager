import 'package:flutter/material.dart';
import 'package:time_manager/core/utils/extensions/string_extensions.dart';
import 'package:time_manager/l10n/app_localizations.dart';

/// Provides reusable validation functions for form inputs.
class Validators {
  
  static String? validateEmail(BuildContext context, String? value) {
            final tr = AppLocalizations.of(context)!;

    if (value == null || value.isEmpty) {
      return tr.emailRequired;
    }
    if (!value.isValidEmail) {
      return tr.invalidEmail;
    }
    return null;
  }

static String? validatePhone(BuildContext context, String? value) {
  final tr = AppLocalizations.of(context)!;
  if (value == null || value.isEmpty) {
    return tr.phoneNumberRequired;
  }
  if (value.length < 8) {
    return tr.invalidPhoneNumber;
  }
  return null;
}


  static String? validatePassword(BuildContext context, String? value) {
                final tr = AppLocalizations.of(context)!;

    if (value == null || value.isEmpty) {
      return tr.passwordRequired;
    }
    if (value.length < 6) {
      return tr.shortPassword;
    }
    return null;
  }

  static String? validateNotEmpty(BuildContext context, String? value, String fieldName) {
                final tr = AppLocalizations.of(context)!;

    if (value == null || value.isEmpty) {
      return tr.fieldIsRequired(fieldName);
    }
    return null;
  }
}
