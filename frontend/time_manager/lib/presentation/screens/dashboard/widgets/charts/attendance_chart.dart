// 📁 lib/presentation/widgets/charts/attendance_chart.dart

import 'package:flutter/material.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/domain/entities/dashboard_report.dart';

class AttendanceChart extends StatelessWidget {
  final PercentKpi punctuality;
  final PercentKpi attendance;
  final String period;

  const AttendanceChart({
    super.key,
    required this.punctuality,
    required this.attendance,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(AppSizes.responsiveWidth(context, AppSizes.p20)),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.r16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Performance',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.p12,
                  vertical: AppSizes.p6,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppSizes.r8),
                ),
                child: Text(
                  period,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p24)),

          // Deux jauges circulaires côte à côte
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildGauge(
                context,
                'Ponctualité',
                punctuality.percent,
                colorScheme.primary,
                Icons.access_time,
              ),
              _buildGauge(
                context,
                'Assiduité',
                attendance.percent,
                colorScheme.secondary,
                Icons.check_circle,
              ),
            ],
          ),

          SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p16)),

          // Légende des niveaux
          _buildLegend(context, colorScheme),
        ],
      ),
    );
  }

  Widget _buildGauge(
    BuildContext context,
    String label,
    double value,
    Color color,
    IconData icon,
  ) {
    final gaugeColor = _getColorForRate(value);

    return Column(
      children: [
        // Jauge circulaire
        SizedBox(
          width: 140,
          height: 140,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Cercle de fond
              SizedBox(
                width: 140,
                height: 140,
                child: CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: 14,
                  backgroundColor: Colors.grey.withOpacity(0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.grey.withOpacity(0.15),
                  ),
                ),
              ),
              // Cercle de progression
              SizedBox(
                width: 140,
                height: 140,
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.easeInOut,
                  tween: Tween<double>(begin: 0, end: value / 100),
                  builder: (context, animatedValue, _) {
                    return CircularProgressIndicator(
                      value: animatedValue,
                      strokeWidth: 14,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(gaugeColor),
                      strokeCap: StrokeCap.round,
                    );
                  },
                ),
              ),
              // Icône et valeur au centre
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 32,
                    color: gaugeColor,
                  ),
                  SizedBox(height: AppSizes.p8),
                  Text(
                    '${value.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: gaugeColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: AppSizes.p12),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildLegend(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(AppSizes.p12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppSizes.r8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildLegendItem('Excellent', Colors.green, '≥ 90%'),
          _buildLegendItem('Bien', Colors.orange, '70-89%'),
          _buildLegendItem('À améliorer', Colors.red, '< 70%'),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, String range) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: AppSizes.p6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              range,
              style: TextStyle(
                fontSize: 9,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getColorForRate(double rate) {
    if (rate >= 90) {
      return Colors.green;
    } else if (rate >= 70) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}