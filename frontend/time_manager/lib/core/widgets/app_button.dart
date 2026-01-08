import 'package:flutter/material.dart';
import 'package:time_manager/core/constants/app_sizes.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool fullSize;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.fullSize = false,
  });

  @override
  Widget build(BuildContext context) {
final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final w = AppSizes.responsiveWidth(context, fullSize ? 300 : 150);
    final h = AppSizes.responsiveHeight(context, fullSize ? 60 : 48);
    final r = BorderRadius.circular(AppSizes.r16);
  final backgroundColor = isLoading
        ? colorScheme.secondary.withValues(alpha: 0.7)
        : colorScheme.secondary;
    final borderColor = colorScheme.shadow.withValues(alpha: 0.6);
    return Material(
      color: Colors.transparent,
      child: Ink(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color:backgroundColor,
          borderRadius: r,
          border: Border.all(
            color: borderColor,
            width: 2,
          ),
        ),
        child: InkWell(
          borderRadius: r,
          onTap: isLoading ? null : onPressed,
          splashColor: colorScheme.primary.withValues(alpha: 0.2),
          highlightColor: colorScheme.primary.withValues(alpha: 0.1),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: child,
              ),
              child: isLoading
                  ? Row(
                      key: const ValueKey('loading'),
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: fullSize ? AppSizes.p24 : 18,
                          height: fullSize ? AppSizes.p24 : 18,
                          child:  CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation(colorScheme.surface),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _buildLoadingText(label),
                          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: fullSize
                ? AppSizes.textLg
                : AppSizes.textMd,
          ),
                        ),
                      ],
                    )
                  : FittedBox(
                      key: const ValueKey('label'),
                      fit: BoxFit.scaleDown,
                      child: Text(
                        label,
                        style: 
                        textTheme.displayLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: fullSize
                ? AppSizes.textDisplay
                              : AppSizes.textXxl,
          ),
                      
                      ),
                    ),
            ),
          ),
        ),
      ),
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
