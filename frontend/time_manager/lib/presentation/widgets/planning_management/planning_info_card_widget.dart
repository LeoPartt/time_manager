
import 'package:flutter/material.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/l10n/app_localizations.dart';

class PlanningInfoCardWidget extends StatelessWidget {
  final int planningCount;
  final ColorScheme colorScheme;
  final AppLocalizations? tr;

  const PlanningInfoCardWidget({
    super.key,
    required this.planningCount,
    required this.colorScheme,
    this.tr,
  });

  @override
  Widget build(BuildContext context) {
    final translations = tr ?? AppLocalizations.of(context)!;
    final percentage = (planningCount / 5 * 100).round();

    return Container(
      padding: EdgeInsets.all(AppSizes.p20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primary.withValues(alpha:0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.r16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha:0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSizes.p16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha:0.2),
                  borderRadius: BorderRadius.circular(AppSizes.r12),
                ),
                child: const Icon(
                  Icons.calendar_month,
                  size: 32,
                  color: Colors.white,
                ),
              ),
              
              SizedBox(width: AppSizes.p16),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$planningCount ${translations.daysConfigured}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: AppSizes.p4),
                    Text(
                      translations.outOf5WorkingDays,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha:0.9),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Pourcentage circulaire
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha:0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$percentage%',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: AppSizes.p16),
          
          // Barre de progression
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.r8),
            child: LinearProgressIndicator(
              value: planningCount / 5,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha:0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}