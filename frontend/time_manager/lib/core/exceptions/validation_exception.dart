import 'package:flutter/material.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'app_exception.dart';

class ValidationException extends AppException {
  ValidationException(super.message, {super.details});

  static ValidationException emptyField(BuildContext context, String field) {
    final tr = AppLocalizations.of(context)!;
    return ValidationException(tr.fieldIsRequired(field));
  }

  static ValidationException invalidEmail(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    return ValidationException(tr.invalidEmail);
  }

  static ValidationException shortPassword(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    return ValidationException(tr.shortPassword);
  }
}
