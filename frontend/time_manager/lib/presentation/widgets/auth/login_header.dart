import 'package:flutter/material.dart';
import 'package:time_manager/core/constants/app_colors.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/l10n/app_localizations.dart';

class LoginHeader extends StatelessWidget {
  final bool isTablet;

  const LoginHeader({
    super.key,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final size = isTablet ? 120.0 : 80.0;

    return Column(
      children: [
        // Logo / Avatar
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha:0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            Icons.timer_outlined,
            size: size * 0.5,
            color: Colors.white,
          ),
        ),
        
        SizedBox(height: AppSizes.p16),
        
        // Titre de l'application
        Text(
          'Time Manager',
          style: TextStyle(
            fontSize: isTablet ? AppSizes.textDisplay : AppSizes.textXxl,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        
        SizedBox(height: AppSizes.p8),
        
        // Sous-titre
        Text(
          tr.appSubtitle,
          style: TextStyle(
            fontSize: AppSizes.textMd,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}