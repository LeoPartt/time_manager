
import 'package:flutter/material.dart';
import 'package:time_manager/core/constants/app_sizes.dart';

class AppLabelContainer extends StatelessWidget {
  final String label;
  final bool fullSize;
  final bool editable;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final TextInputType keyboardType;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;

  const AppLabelContainer({
    super.key,
    required this.label,
    this.fullSize = false,
    this.editable = false,
    this.controller,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.icon,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final bgColor = backgroundColor ?? colorScheme.primaryContainer;
    final txtColor = textColor ?? colorScheme.onPrimaryContainer;

    return Container(
      constraints: BoxConstraints(
        minWidth: fullSize ? 200 : 120,
        minHeight: fullSize ? 56 : 48,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.p16,
        vertical: AppSizes.p12,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSizes.r12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha:0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha:0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: txtColor.withValues(alpha:0.7),
              size: fullSize ? 22 : 18,
            ),
            SizedBox(width: AppSizes.p8),
          ],
          Flexible(
            child: editable
                ? TextField(
                    controller: controller,
                    onChanged: onChanged,
                    keyboardType: keyboardType,
                    style: TextStyle(
                      color: txtColor,
                      fontSize: AppSizes.responsiveText(
                        context,
                        fullSize ? AppSizes.textLg : AppSizes.textMd,
                      ),
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: label,
                      hintStyle: TextStyle(
                        color: txtColor.withValues(alpha:0.5),
                      ),
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  )
                : Text(
                    label,
                    style: TextStyle(
                      color: txtColor,
                      fontSize: AppSizes.responsiveText(
                        context,
                        fullSize ? AppSizes.textLg : AppSizes.textMd,
                      ),
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
          ),
        ],
      ),
    );
  }
}

// ✅ Variantes pour différents usages

class AppStatusChip extends StatelessWidget {
  final String label;
  final Color? color;
  final IconData? icon;

  const AppStatusChip({
    super.key,
    required this.label,
    this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AppLabelContainer(
      label: label,
      icon: icon,
      backgroundColor: color?.withValues(alpha:0.1),
      textColor: color,
    );
  }
}

class AppInfoChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const AppInfoChip({
    super.key,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AppLabelContainer(
      label: label,
      icon: icon,
    );
  }
}