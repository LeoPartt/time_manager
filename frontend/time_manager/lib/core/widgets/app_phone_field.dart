import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/l10n/app_localizations.dart';

typedef StringValidator = FutureOr<String?> Function(PhoneNumber?);


class AppPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final ValueChanged<String>? onChanged;
  final String? initialCountryCode;
  final StringValidator? validator;

  const AppPhoneField({
    super.key,
            this.validator,

    required this.controller,
    required this.label,
    this.onChanged,
    this.initialCountryCode = 'EN', 
  });

  @override
  Widget build(BuildContext context) {
        final theme = Theme.of(context);
            final tr = AppLocalizations.of(context)!;

    return IntlPhoneField(
            validator: validator,

      controller: controller,
      initialCountryCode: initialCountryCode,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: theme.textTheme.bodySmall?.copyWith(
          fontSize: AppSizes.responsiveText(context, AppSizes.textSm),
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.r12),
          borderSide: BorderSide(
            color: theme.colorScheme.outline
           
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.r12),
          borderSide:
              BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest,
      ),
      style: theme.textTheme.bodyMedium?.copyWith(
        fontSize: AppSizes.responsiveText(context, AppSizes.textMd),
      ),
      onChanged: (phone) {
        controller.text = phone.completeNumber; 
        if (onChanged != null) onChanged!(phone.completeNumber);
      },
      invalidNumberMessage: tr.invalidPhoneNumber,
    );
  }
}
