
import 'package:flutter/material.dart';
import 'package:time_manager/core/constants/app_colors.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/core/widgets/app_button.dart';

class ErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final bool showDetailedError;

  const ErrorStateWidget({
    super.key,
    required this.message,
    required this.onRetry,
    this.showDetailedError = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSizes.p24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icône erreur
            Container(
              padding: EdgeInsets.all(AppSizes.p20),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha:0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: AppColors.error,
              ),
            ),
            
            SizedBox(height: AppSizes.p24),
            
            // Titre
            Text(
              'Une erreur est survenue',
              style: TextStyle(
                fontSize: AppSizes.textLg,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            
            SizedBox(height: AppSizes.p12),
            
            // Message
            if (showDetailedError)
              Container(
                padding: EdgeInsets.all(AppSizes.p16),
                margin: EdgeInsets.symmetric(horizontal: AppSizes.p16),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha:0.05),
                  borderRadius: BorderRadius.circular(AppSizes.r12),
                  border: Border.all(
                    color: AppColors.error.withValues(alpha:0.2),
                  ),
                ),
                child: SelectableText(
                  message,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: AppSizes.textSm,
                    fontFamily: 'monospace',
                    color: AppColors.error.withValues(alpha:0.8),
                  ),
                ),
              )
            else
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.p16),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppSizes.textMd,
                    color: colorScheme.onSurface.withValues(alpha:0.6),
                  ),
                ),
              ),
            
            SizedBox(height: AppSizes.p32),
            
            // Bouton retry
            AppButton(
              label: 'Réessayer',
              onPressed: onRetry,
              icon: Icons.refresh_rounded,
            ),
          ],
        ),
      ),
    );
  }
}