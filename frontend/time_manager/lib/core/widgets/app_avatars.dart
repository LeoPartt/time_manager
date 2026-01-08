import 'package:flutter/material.dart';
import 'package:time_manager/core/constants/app_sizes.dart';

/// A reusable circular avatar widget for user profile images or icons.
class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final IconData fallbackIcon;
  final Color? backgroundColor;
  final Color? iconColor;
  final VoidCallback? onTap;
  final bool showBorder;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.radius = AppSizes.r32,
    this.fallbackIcon = Icons.person_outline,
    this.backgroundColor,
    this.iconColor,
    this.onTap,
    this.showBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final bgColor = backgroundColor ?? colorScheme.surface;
    final borderColor = colorScheme.primary.withValues(alpha:0.3);
    final iconCol = iconColor ?? colorScheme.primary;

    final avatar = CircleAvatar(
      radius: radius,
      backgroundColor: bgColor,
      backgroundImage:
          (imageUrl != null && imageUrl!.isNotEmpty) ? NetworkImage(imageUrl!) : null,
      child: (imageUrl == null || imageUrl!.isEmpty)
          ? Icon(fallbackIcon, color: iconCol, size: radius * 0.9)
          : null,
    );

    return GestureDetector(
      onTap: onTap,
      child: showBorder
          ? Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                
                border: Border.all(color: borderColor, width: 2),
                boxShadow:  [
                                    BoxShadow(
                                      color: colorScheme.shadow.withValues(alpha: 0.2),
                                      offset: Offset(0, 2),
                                      blurRadius: 6,
                                    ),
                                  ],
              ),
              
              padding: const EdgeInsets.all(2),
              child: avatar,
            )
          : avatar,
    );
  }
}
