
import 'package:flutter/material.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/domain/entities/schedule/daily_work.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/widgets/planning_calendar/simplified_view_widget.dart';
import 'package:time_manager/presentation/widgets/planning_calendar/detailed_view_widget.dart';

class DayDetailsWidget extends StatelessWidget {
  final DateTime day;
  final DailyWork? dailyWork;
  final bool isLoading;
  final bool showDetailedPeriods;
  final VoidCallback onToggleDetailedView;
  final ColorScheme colorScheme;

  const DayDetailsWidget({
    super.key,
    required this.day,
    required this.dailyWork,
    required this.isLoading,
    required this.showDetailedPeriods,
    required this.onToggleDetailedView,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingState();
    }

    if (dailyWork == null) {
      return _buildNoDataState(context);
    }

    return _buildDetailsCard(context);
  }

  Widget _buildLoadingState() {
    return Container(
      padding: EdgeInsets.all(AppSizes.p20),
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
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildNoDataState(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    
    return Container(
      padding: EdgeInsets.all(AppSizes.p20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSizes.r16),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.grey[600]),
          SizedBox(width: AppSizes.p12),
          Text(
            tr.noDataForThisDay,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.p20),
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
          _buildHeader(context),
          SizedBox(height: AppSizes.p16),
          _buildPlannedSchedule(context),
          SizedBox(height: AppSizes.p12),
          _buildActualWork(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.event, color: colorScheme.primary),
            SizedBox(width: AppSizes.p8),
            Text(
              _formatDate(day, context),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        if (dailyWork!.workPeriods.length > 1)
          IconButton(
            icon: Icon(
              showDetailedPeriods ? Icons.view_list : Icons.view_compact,
              color: colorScheme.primary,
            ),
            onPressed: onToggleDetailedView,
            tooltip: showDetailedPeriods ? tr.simplifiedView : tr.detailedView,
          ),
      ],
    );
  }

  Widget _buildPlannedSchedule(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    
    if (dailyWork!.planned != null) {
      return _buildScheduleRow(
        context,
        '📋 ${tr.planned}',
        '${dailyWork!.planned!.startTime} - ${dailyWork!.planned!.endTime}',
        '${dailyWork!.planned!.totalHours.toStringAsFixed(1)}h',
        colorScheme.primary,
      );
    }

    return _buildNoDataRow(
      context,
      '📋 ${tr.planned}',
      tr.noPlanning,
      Colors.grey,
    );
  }

  Widget _buildActualWork(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    
    if (dailyWork!.workPeriods.isEmpty) {
      return _buildNoDataRow(
        context,
        '✅ ${tr.actual}',
        tr.noClocking,
        Colors.grey,
      );
    }

    if (showDetailedPeriods) {
      return DetailedViewWidget(
        dailyWork: dailyWork!,
        colorScheme: colorScheme,
      );
    }

    return SimplifiedViewWidget(
      dailyWork: dailyWork!,
      colorScheme: colorScheme,
      onToggleDetailedView: onToggleDetailedView,
    );
  }

  Widget _buildScheduleRow(
    BuildContext context,
    String label,
    String time,
    String hours,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(AppSizes.p12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.r12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: AppSizes.p12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: AppSizes.p4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.p12,
              vertical: AppSizes.p6,
            ),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppSizes.r8),
            ),
            child: Text(
              hours,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataRow(
    BuildContext context,
    String label,
    String message,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(AppSizes.p12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.r12),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: color, size: 20),
          SizedBox(width: AppSizes.p12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  message,
                  style: TextStyle(fontSize: 13, color: color),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date, BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    
    final days = [
      tr.monday,
      tr.tuesday,
      tr.wednesday,
      tr.thursday,
      tr.friday,
      tr.saturday,
      tr.sunday,
    ];
    
    final months = [
      tr.january,
      tr.february,
      tr.march,
      tr.april,
      tr.may,
      tr.june,
      tr.july,
      tr.august,
      tr.september,
      tr.october,
      tr.november,
      tr.december,
    ];

    final dayName = days[date.weekday - 1];
    final monthName = months[date.month - 1];

    return '$dayName ${date.day} $monthName ${date.year}';
  }
}