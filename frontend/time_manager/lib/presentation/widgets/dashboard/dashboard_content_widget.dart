import 'package:flutter/material.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/domain/entities/dashboard/dashboard_report.dart';
import 'package:time_manager/presentation/screens/dashboard/widgets/charts/attendance_chart.dart';
import 'package:time_manager/presentation/screens/dashboard/widgets/charts/monthly_work_chart.dart';
import 'package:time_manager/presentation/screens/dashboard/widgets/charts/weekly_work_chart.dart';
import 'package:time_manager/presentation/screens/dashboard/widgets/charts/yearly_work_chart.dart';
import 'package:time_manager/presentation/widgets/dashboard/period_selector_widget.dart';

class DashboardContentWidget extends StatelessWidget {
  final DashboardReport report;
  final ReportPeriod selectedPeriod;
  final Function(ReportPeriod) onPeriodChanged;
  final ColorScheme colorScheme;
  final Color? periodButtonColor;
  final Widget? additionalActions;

  const DashboardContentWidget({
    super.key,
    required this.report,
    required this.selectedPeriod,
    required this.onPeriodChanged,
    required this.colorScheme,
    this.periodButtonColor,
    this.additionalActions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sélecteur de période
        PeriodSelectorWidget(
          selectedPeriod: selectedPeriod,
          onPeriodChanged: onPeriodChanged,
          colorScheme: colorScheme,
          buttonColor: periodButtonColor,
        ),
        SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p24)),

        // Chart Attendance/Punctuality
        AttendanceChart(
          punctuality: report.punctuality,
          attendance: report.attendance,
          period: _getPeriodLabel(),
        ),

        SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p24)),

        // Work Chart dynamique
        _buildWorkChartForPeriod(context, report.work),

        if (additionalActions != null) ...[
          SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p24)),
          additionalActions!,
        ],
      ],
    );
  }

  Widget _buildWorkChartForPeriod(BuildContext context, WorkSeries workSeries) {
    switch (selectedPeriod) {
      case ReportPeriod.week:
        return WeeklyWorkChart(workSeries: workSeries);
      case ReportPeriod.month:
        return MonthlyWorkChart(workSeries: workSeries);
      case ReportPeriod.year:
        return YearlyWorkChart(workSeries: workSeries);
    }
  }

  String _getPeriodLabel() {
    switch (selectedPeriod) {
      case ReportPeriod.week:
        return 'Hebdomadaire';
      case ReportPeriod.month:
        return 'Mensuel';
      case ReportPeriod.year:
        return 'Annuel';
    }
  }
}