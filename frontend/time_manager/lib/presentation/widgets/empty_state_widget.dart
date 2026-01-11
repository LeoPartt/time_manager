
import 'package:flutter/material.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/core/widgets/app_button.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? buttonLabel;
  final VoidCallback? onButtonPressed;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.buttonLabel,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSizes.p32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icône avec cercle coloré
            Container(
              padding: EdgeInsets.all(AppSizes.p24),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha:0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: colorScheme.primary.withValues(alpha:0.7),
              ),
            ),
            
            SizedBox(height: AppSizes.p24),
            
            // Titre
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppSizes.textXl,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            
            SizedBox(height: AppSizes.p12),
            
            // Sous-titre
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppSizes.textMd,
                color: colorScheme.onSurface.withValues(alpha:0.6),
                height: 1.5,
              ),
            ),
            
            if (buttonLabel != null && onButtonPressed != null) ...[
              SizedBox(height: AppSizes.p32),
              AppButton(
                label: buttonLabel!,
                onPressed: onButtonPressed!,
                icon: Icons.add_rounded,
              ),
            ],
          ],
        ),
      ),
    );
  }
}