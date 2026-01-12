
import 'package:flutter/material.dart';
import 'package:time_manager/core/constants/app_sizes.dart';

class Header extends StatelessWidget {
  final String label;
  final Widget? leading;
  final List<Widget>? actions;

  const Header({
    super.key,
    required this.label,
    this.leading,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final colorScheme = Theme.of(context).colorScheme;
    final isTablet = size.width >= 600;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.p20,
        vertical: AppSizes.p16,
      ),
      margin: EdgeInsets.only(
        top: AppSizes.responsiveHeight(context, AppSizes.p12),
        left: AppSizes.p16,
        right: AppSizes.p16,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.r16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha:0.1),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            SizedBox(width: AppSizes.p12),
          ],
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: isTablet ? AppSizes.textXxl : AppSizes.textXl,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}