// 📁 lib/presentation/widgets/attendance_chart.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:time_manager/core/constants/app_sizes.dart';

class AttendanceChart extends StatelessWidget {
  final double punctualityRate;
  final double attendanceRate;

  const AttendanceChart({
    super.key,
    required this.punctualityRate,
    required this.attendanceRate,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 280,
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
          // Titre
          Text(
            'Performance',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p16)),

          // Chart
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                minY: 0,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => colorScheme.inverseSurface,
                    tooltipPadding: const EdgeInsets.all(8),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      String label = groupIndex == 0 ? 'Ponctualité' : 'Assiduité';
                      return BarTooltipItem(
                        '$label\n${rod.toY.toStringAsFixed(1)}%',
                        TextStyle(
                          color: colorScheme.onInverseSurface,
                          fontWeight: FontWeight.bold,
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
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        );
                        switch (value.toInt()) {
                          case 0:
                            return const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text('Ponctualité', style: style),
                            );
                          case 1:
                            return const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text('Assiduité', style: style),
                            );
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
                      interval: 20,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}%',
                          style: const TextStyle(fontSize: 12),
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
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  // Ponctualité
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: punctualityRate,
                        color: _getColorForRate(punctualityRate, colorScheme),
                        width: 50,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 100,
                          color: Colors.grey.withOpacity(0.1),
                        ),
                      ),
                    ],
                    showingTooltipIndicators: [0],
                  ),
                  // Assiduité
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: attendanceRate,
                        color: _getColorForRate(attendanceRate, colorScheme),
                        width: 50,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 100,
                          color: Colors.grey.withOpacity(0.1),
                        ),
                      ),
                    ],
                    showingTooltipIndicators: [0],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p12)),

          // Légende
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(
                'Excellent',
                Colors.green,
                '≥ 90%',
              ),
              SizedBox(width: AppSizes.p16),
              _buildLegendItem(
                'Bien',
                Colors.orange,
                '70-89%',
              ),
              SizedBox(width: AppSizes.p16),
              _buildLegendItem(
                'À améliorer',
                Colors.red,
                '< 70%',
              ),
            ],
          ),
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
        const SizedBox(width: 4),
        Text(
          '$label ($range)',
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }

  Color _getColorForRate(double rate, ColorScheme colorScheme) {
    if (rate >= 90) {
      return Colors.green; // Excellent
    } else if (rate >= 70) {
      return Colors.orange; // Bien
    } else {
      return Colors.red; // À améliorer
    }
  }
}