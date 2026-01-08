import 'package:flutter/material.dart';
import '../constants/app_sizes.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;


    return InkWell(
                              radius: AppSizes.r24,

      borderRadius: BorderRadius.circular(AppSizes.r16),
      onTap: onTap,
      child: Container(
        width: width != null
            ? AppSizes.responsiveWidth(context, width!)
            : null,
        height: height != null
            ? AppSizes.responsiveHeight(context, height!)
            : null,
        padding: padding ??
            EdgeInsets.all(AppSizes.responsiveWidth(context, AppSizes.p16)),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(AppSizes.r16),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha:0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
