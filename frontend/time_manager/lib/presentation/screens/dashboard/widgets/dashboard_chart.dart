// 📁 lib/presentation/widgets/work_chart.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:time_manager/core/constants/app_sizes.dart';

class WorkChart extends StatelessWidget {
  final double weeklyHours;
  final double monthlyHours;

  const WorkChart({
    super.key,
    required this.weeklyHours,
    required this.monthlyHours,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 200,
      padding: EdgeInsets.all(AppSizes.responsiveWidth(context, AppSizes.p16)),
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
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: monthlyHours * 1.2,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => colorScheme.inverseSurface,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String label = groupIndex == 0 ? 'Hebdo' : 'Mensuel';
                return BarTooltipItem(
                  '$label\n${rod.toY.toStringAsFixed(1)}h',
                  TextStyle(color: colorScheme.onInverseSurface),
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
                  switch (value.toInt()) {
                    case 0:
                      return Text('Hebdo', style: TextStyle(fontSize: 12));
                    case 1:
                      return Text('Mensuel', style: TextStyle(fontSize: 12));
                    default:
                      return const SizedBox();
                  }
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text('${value.toInt()}h', style: TextStyle(fontSize: 10));
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: weeklyHours,
                  color: colorScheme.primary,
                  width: 40,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: monthlyHours,
                  color: colorScheme.secondary,
                  width: 40,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}