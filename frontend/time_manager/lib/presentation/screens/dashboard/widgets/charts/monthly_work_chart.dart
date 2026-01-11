import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/domain/entities/dashboard/dashboard_report.dart';

class MonthlyWorkChart extends StatelessWidget {
  final WorkSeries workSeries;
  
  const MonthlyWorkChart({
    super.key,
    required this.workSeries,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    // ✅ Convertir les WorkPoints en BarChartGroupData
    final monthData = workSeries.series.asMap().entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value.value,
            gradient: _getGradientForWeek(entry.key, colorScheme),
            width: 50,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(8),
            ),
          ),
        ],
      );
    }).toList();

    return Container(
      height: 300,
      padding: EdgeInsets.all(AppSizes.responsiveWidth(context, AppSizes.p20)),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.r16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha:0.1),
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
                    'Moyenne : ${workSeries.average.toStringAsFixed(1)}h/semaine',
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
                  '${_calculateTotal().toStringAsFixed(1)}h',
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
                      if (groupIndex >= 0 && groupIndex < workSeries.series.length) {
                        final label = workSeries.series[groupIndex].label;
                        return BarTooltipItem(
                          '$label\n${rod.toY.toStringAsFixed(1)}h',
                          TextStyle(
                            color: colorScheme.onInverseSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= workSeries.series.length) {
                          return const SizedBox();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            workSeries.series[index].label,
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
                      color: Colors.grey.withValues(alpha:0.15),
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
        ],
      ),
    );
  }

  double _calculateTotal() {
    return workSeries.series.fold(0.0, (sum, point) => sum + point.value);
  }

  double _getMaxY(List<BarChartGroupData> data) {
    if (data.isEmpty) return 50;
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
        baseColor.withValues(alpha:0.7),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }
}