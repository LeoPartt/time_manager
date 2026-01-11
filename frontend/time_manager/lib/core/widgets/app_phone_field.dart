
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/l10n/app_localizations.dart';

typedef PhoneValidator = FutureOr<String?> Function(PhoneNumber?);

class AppPhoneField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final ValueChanged<String>? onChanged;
  final String? initialCountryCode;
  final PhoneValidator? validator;
  final bool enabled;

  const AppPhoneField({
    super.key,
    required this.controller,
    this.label,
    this.onChanged,
    this.initialCountryCode,
    this.validator,
    this.enabled = true,
  });

  @override
  State<AppPhoneField> createState() => _AppPhoneFieldState();
}

class _AppPhoneFieldState extends State<AppPhoneField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final tr = AppLocalizations.of(context)!;

    // Récupérer le code pays par défaut
    final defaultCountry = widget.initialCountryCode ?? _getDefaultCountryCode();

    return IntlPhoneField(
      controller: widget.controller,
      initialCountryCode: defaultCountry,
      enabled: widget.enabled,
      validator: widget.validator,
      
      decoration: InputDecoration(
        labelText: widget.label ,
        
        labelStyle: theme.textTheme.bodySmall?.copyWith(
          fontSize: AppSizes.responsiveText(context, AppSizes.textSm),
          color: _isFocused 
              ? colorScheme.primary 
              : colorScheme.onSurface.withValues(alpha:0.6),
          fontWeight: FontWeight.w500,
        ),
        
        filled: true,
        fillColor: widget.enabled
            ? colorScheme.surfaceContainerHighest
            : colorScheme.surfaceContainerHighest.withValues(alpha:0.5),
        
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSizes.p16,
          vertical: AppSizes.p16,
        ),
        
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.r12),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha:0.3),
          ),
        ),
        
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.r12),
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha:0.3),
          ),
        ),
        
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.r12),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
        
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.r12),
          borderSide: BorderSide(
            color: colorScheme.error,
          ),
        ),
        
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.r12),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 2,
          ),
        ),
      ),
      
      style: theme.textTheme.bodyMedium?.copyWith(
        fontSize: AppSizes.responsiveText(context, AppSizes.textMd),
        fontWeight: FontWeight.w500,
      ),
      
      dropdownTextStyle: theme.textTheme.bodyMedium?.copyWith(
        fontSize: AppSizes.responsiveText(context, AppSizes.textMd),
      ),
      
      invalidNumberMessage: tr.invalidPhoneNumber,
 
      
      onChanged: (phone) {
        setState(() {});
        widget.controller.text = phone.completeNumber;
        widget.onChanged?.call(phone.completeNumber);
      },
      
      onTap: () => setState(() => _isFocused = true),
      onSubmitted: (_) => setState(() => _isFocused = false),
    );
  }

  String _getDefaultCountryCode() {
    final locale = Localizations.localeOf(context);
    final countryCode = locale.countryCode?.toUpperCase();
    
    // Mapping des codes de pays communs
    final validCodes = ['FR', 'US', 'GB', 'DE', 'ES', 'IT', 'BE', 'CH', 'CA'];
    
    if (countryCode != null && validCodes.contains(countryCode)) {
      return countryCode;
    }
    
    return 'FR'; // Par défaut
  }
}