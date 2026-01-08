// 📁 lib/presentation/widgets/charts/monthly_work_chart.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:time_manager/core/constants/app_sizes.dart';

class MonthlyWorkChart extends StatelessWidget {
  final double totalHours;
  
  const MonthlyWorkChart({
    super.key,
    required this.totalHours,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final monthData = _generateMonthData(totalHours, colorScheme);

    return Container(
      height: 300,
      padding: EdgeInsets.all(AppSizes.responsiveWidth(context, AppSizes.p20)),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.r16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Travail mensuel',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: AppSizes.p4),
                  Text(
                    'Par semaine',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.p12,
                  vertical: AppSizes.p8,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(AppSizes.r8),
                ),
                child: Text(
                  '${totalHours.toStringAsFixed(1)}h',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p16)),
          
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _getMaxY(monthData),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => colorScheme.inverseSurface,
                    tooltipPadding: const EdgeInsets.all(8),
                    
                    tooltipBorderRadius: BorderRadius.all(Radius.circular(8)),

                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        'Semaine ${groupIndex + 1}\n${rod.toY.toStringAsFixed(1)}h',
                        TextStyle(
                          color: colorScheme.onInverseSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value < 0 || value > 3) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'S${value.toInt() + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}h',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withValues(alpha: 0.15),
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                barGroups: monthData,
              ),
            ),
          ),
          
          SizedBox(height: AppSizes.p12),
          _buildLegend(context, colorScheme),
        ],
      ),
    );
  }

  Widget _buildLegend(BuildContext context, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('En progression', colorScheme.primary),
        SizedBox(width: AppSizes.p16),
        _buildLegendItem('Stable', colorScheme.secondary),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: AppSizes.p4),
        Text(
          label,
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }

  List<BarChartGroupData> _generateMonthData(
    double totalHours,
    ColorScheme colorScheme,
  ) {
    final avgPerWeek = totalHours / 4;
    
    // ✅ Calcule le maxY AVANT de créer les barres
    final maxValue = avgPerWeek * 1.15; // La 4ème semaine sera la plus haute
    
    return List.generate(4, (index) {
      final weekHours = avgPerWeek * (0.85 + (index * 0.1));
    
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: weekHours,
            gradient: _getGradientForWeek(index, colorScheme),
            width: 50,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(8),
            ),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              // ✅ Utilise le maxValue calculé (pas de récursion)
              toY: maxValue * 1.3,
              color: Colors.grey.withValues(alpha: 0.1),
            ),
          ),
        ],
      );
    });
  }

  // ✅ Simplifie _getMaxY (pas besoin de _generateMonthDataForMax)
  double _getMaxY(List<BarChartGroupData> data) {
    final max = data
        .map((e) => e.barRods.first.toY)
        .reduce((a, b) => a > b ? a : b);
    return (max * 1.3).ceilToDouble();
  }

  LinearGradient _getGradientForWeek(int week, ColorScheme colorScheme) {
    final baseColor = week < 2 ? colorScheme.secondary : colorScheme.primary;
    return LinearGradient(
      colors: [
        baseColor,
        baseColor.withValues(alpha: 0.7),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }
}