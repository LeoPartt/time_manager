import 'package:flutter/material.dart';
import 'package:time_manager/core/constants/app_colors.dart';
import 'package:time_manager/core/constants/app_sizes.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool fullSize;
  final bool isLoading;
  final bool isOutlined; // ✅ Nouveau : style outlined
  final IconData? icon; // ✅ Nouveau : icône optionnelle
  final Color? backgroundColor;
  final Color? textColor;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.fullSize = false,
    this.isOutlined = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // ✅ Couleurs adaptatives
    final btnBgColor = backgroundColor ?? 
        (isOutlined 
            ? Colors.transparent 
            : (isLoading 
                ? colorScheme.primary.withValues(alpha:0.7) 
                : colorScheme.primary));
    
    final btnTextColor = textColor ?? 
        (isOutlined ? colorScheme.primary : Colors.white);
    
    final borderColor = isOutlined ? colorScheme.primary : Colors.transparent;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(AppSizes.r12),
        splashColor: colorScheme.primary.withValues(alpha:0.2),
        highlightColor: colorScheme.primary.withValues(alpha:0.1),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: fullSize ? double.infinity : 400,
          height: AppSizes.responsiveHeight(context, fullSize ? 56 : 48),
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.responsiveWidth(context, fullSize ? AppSizes.p24 : AppSizes.p20),
            vertical: AppSizes.p12,
          ),
          decoration: BoxDecoration(
            color: btnBgColor,
            borderRadius: BorderRadius.circular(AppSizes.r12),
            border: Border.all(
              color: borderColor,
              width: isOutlined ? 2 : 0,
            ),
            boxShadow: isOutlined || isLoading
                ? []
                : [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha:0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: animation,
                child: child,
              ),
            ),
            child: isLoading
                ? _buildLoadingState(context, btnTextColor, fullSize)
                : _buildNormalState(context, btnTextColor, fullSize),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context, Color textColor, bool fullSize) {
    return Row(
      key: const ValueKey('loading'),
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: fullSize ? 20 : 16,
          height: fullSize ? 20 : 16,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation(textColor),
          ),
        ),
        SizedBox(width: AppSizes.p12),
        Text(
          _buildLoadingText(label),
          style: TextStyle(
            color: textColor,
            fontSize: AppSizes.responsiveText(
              context,
              fullSize ? AppSizes.textLg : AppSizes.textMd,
            ),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildNormalState(BuildContext context, Color textColor, bool fullSize) {
    return Row(
      key: const ValueKey('normal'),
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            color: textColor,
            size: fullSize ? 22 : 18,
          ),
          SizedBox(width: AppSizes.p8),
        ],
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: AppSizes.responsiveText(
                context,
                fullSize ? AppSizes.textLg : AppSizes.textMd,
              ),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  /// Transforme automatiquement "Create User" → "Creating..."
  static String _buildLoadingText(String text) {
    final parts = text.split(' ');
    if (parts.length == 1) {
      // Ex: "Save" -> "Saving..."
      return text.endsWith('e')
          ? '${text.substring(0, text.length - 1)}ing...'
          : '${text}ing...';
    } else {
      // Ex: "Create User" -> "Creating..."
      return '${parts.first}ing...';
    }
  }
}

// ✅ Variantes pour faciliter l'utilisation

class AppPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool fullSize;
  final IconData? icon;

  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.fullSize = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      fullSize: fullSize,
      icon: icon,
    );
  }
}

class AppOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool fullSize;
  final IconData? icon;

  const AppOutlinedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.fullSize = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      fullSize: fullSize,
      isOutlined: true,
      icon: icon,
    );
  }
}

class AppDangerButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool fullSize;
  final IconData? icon;

  const AppDangerButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.fullSize = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      fullSize: fullSize,
      backgroundColor: AppColors.error,
      icon: icon,
    );
  }
}