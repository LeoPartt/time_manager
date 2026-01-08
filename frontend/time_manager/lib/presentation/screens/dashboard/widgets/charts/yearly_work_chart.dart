// 📁 lib/presentation/widgets/charts/yearly_work_chart.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:time_manager/core/constants/app_sizes.dart';

class YearlyWorkChart extends StatelessWidget {
  final double totalHours;
  
  const YearlyWorkChart({
    super.key,
    required this.totalHours,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final yearData = _generateYearData(totalHours);

    return Container(
      height: 300,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Travail annuel',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: AppSizes.p4),
                  Text(
                    '12 derniers mois',
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
                  color: colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(AppSizes.r8),
                ),
                child: Text(
                  '${totalHours.toStringAsFixed(0)}h',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onTertiaryContainer,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p16)),
          
          Expanded(
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: _getMaxY(yearData),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => colorScheme.inverseSurface,
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipBorderRadius: BorderRadius.all(Radius.circular(8)),
                    getTooltipItems: (spots) {
                      return spots.map((spot) {
                        final month = _getMonthName(spot.x.toInt());
                        return LineTooltipItem(
                          '$month\n${spot.y.toStringAsFixed(1)}h',
                          TextStyle(
                            color: colorScheme.onInverseSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.15),
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        if (value < 0 || value > 11) return const SizedBox();
                        // Affiche un mois sur deux pour éviter le chevauchement
                        if (value.toInt() % 2 != 0) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _getMonthShortName(value.toInt()),
                            style: TextStyle(
                              fontSize: 10,
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
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: yearData,
                    isCurved: true,
                    curveSmoothness: 0.4,
                    color: colorScheme.tertiary,
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: colorScheme.tertiary,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.tertiary.withOpacity(0.3),
                          colorScheme.tertiary.withOpacity(0.1),
                          colorScheme.tertiary.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Indicateur de tendance
          SizedBox(height: AppSizes.p12),
          _buildTrendIndicator(context, yearData, colorScheme),
        ],
      ),
    );
  }

  Widget _buildTrendIndicator(
    BuildContext context,
    List<FlSpot> data,
    ColorScheme colorScheme,
  ) {
    final firstHalf = data.sublist(0, 6).map((e) => e.y).reduce((a, b) => a + b) / 6;
    final secondHalf = data.sublist(6).map((e) => e.y).reduce((a, b) => a + b) / 6;
    final trend = secondHalf - firstHalf;
    final isPositive = trend > 0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.p12,
        vertical: AppSizes.p8,
      ),
      decoration: BoxDecoration(
        color: (isPositive ? Colors.green : Colors.orange).withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.r8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.trending_up : Icons.trending_down,
            size: 16,
            color: isPositive ? Colors.green : Colors.orange,
          ),
          SizedBox(width: AppSizes.p4),
          Text(
            isPositive
                ? 'En hausse de ${trend.toStringAsFixed(1)}h/mois'
                : 'En baisse de ${(-trend).toStringAsFixed(1)}h/mois',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isPositive ? Colors.green : Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _generateYearData(double totalHours) {
    // TODO: Remplacer par vraies données de l'API
    final avgPerMonth = totalHours / 12;
    
    return List.generate(12, (index) {
      // Simulation avec variations saisonnières réalistes
      // Moins d'heures en été (juillet-août), plus au printemps et automne
      double seasonalFactor;
      if (index >= 6 && index <= 7) {
        // Juillet-Août : vacances
        seasonalFactor = 0.7;
      } else if (index == 11 || index == 0) {
        // Décembre-Janvier : fin/début d'année
        seasonalFactor = 0.85;
      } else {
        // Reste de l'année
        seasonalFactor = 1.0 + (0.1 * ((index % 3) - 1));
      }
      
      return FlSpot(
        index.toDouble(),
        avgPerMonth * seasonalFactor,
      );
    });
  }

  double _getMaxY(List<FlSpot> data) {
    final max = data.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    return (max * 1.3).ceilToDouble();
  }

  String _getMonthName(int month) {
    const months = [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];
    return months[month];
  }

  String _getMonthShortName(int month) {
    const months = [
      'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun',
      'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'
    ];
    return months[month];
  }
}