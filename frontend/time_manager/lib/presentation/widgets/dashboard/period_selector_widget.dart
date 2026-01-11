import 'package:flutter/material.dart';
import 'package:time_manager/core/constants/app_sizes.dart';

enum ReportPeriod { week, month, year }

class PeriodSelectorWidget extends StatelessWidget {
  final ReportPeriod selectedPeriod;
  final Function(ReportPeriod) onPeriodChanged;
  final ColorScheme colorScheme;
  final Color? buttonColor;

  const PeriodSelectorWidget({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
    required this.colorScheme,
    this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.p4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSizes.r12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildPeriodButton(
              context,
              'Semaine',
              ReportPeriod.week,
            ),
          ),
          Expanded(
            child: _buildPeriodButton(
              context,
              'Mois',
              ReportPeriod.month,
            ),
          ),
          Expanded(
            child: _buildPeriodButton(
              context,
              'Année',
              ReportPeriod.year,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(
    BuildContext context,
    String label,
    ReportPeriod period,
  ) {
    final isSelected = selectedPeriod == period;
    final activeColor = buttonColor ?? colorScheme.primary;

    return GestureDetector(
      onTap: () => onPeriodChanged(period),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppSizes.p12,
          horizontal: AppSizes.p16,
        ),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSizes.r8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected 
                ? (buttonColor != null ? Colors.white : colorScheme.onPrimary)
                : colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}