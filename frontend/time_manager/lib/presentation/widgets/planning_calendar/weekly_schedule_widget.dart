import 'package:flutter/material.dart';
import 'package:time_manager/core/constants/app_sizes.dart';

class WeeklyScheduleWidget extends StatelessWidget {
  final List<dynamic> plannings;
  final ColorScheme colorScheme;

  const WeeklyScheduleWidget({
    super.key,
    required this.plannings,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.p20),
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
          _buildHeader(context),
          SizedBox(height: AppSizes.p16),
          if (plannings.isEmpty)
            _buildEmptyState(context)
          else
            _buildPlanningsList(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Text(
      'Planning hebdomadaire',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.p20),
        child: Column(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            SizedBox(height: AppSizes.p16),
            Text(
              'Aucun planning configuré',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanningsList(BuildContext context) {
    // Trier par jour de la semaine
    final sortedPlannings = List<dynamic>.from(plannings)
      ..sort((a, b) => a.weekDay.compareTo(b.weekDay));

    return Column(
      children: sortedPlannings.map((planning) {
        return _buildPlanningItem(context, planning);
      }).toList(),
    );
  }

  Widget _buildPlanningItem(BuildContext context, dynamic planning) {
    final weekDayName = _getWeekDayName(planning.weekDay);
    final startTime = _formatTime(planning.startTime);
    final endTime = _formatTime(planning.endTime);

    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.p12),
      padding: EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha:0.3),
        borderRadius: BorderRadius.circular(AppSizes.r12),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha:0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: AppSizes.p16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  weekDayName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: AppSizes.p4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: AppSizes.p4),
                    Text(
                      '$startTime - $endTime',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getWeekDayName(int weekDay) {
    const days = [
      'Lundi',
      'Mardi',
      'Mercredi',
      'Jeudi',
      'Vendredi',
      'Samedi',
      'Dimanche',
    ];
    return days[weekDay];
  }

  String _formatTime(dynamic time) {
    if (time is String) {
      return time.substring(0, 5);
    }
    return time.toString();
  }
}