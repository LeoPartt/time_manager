
import 'package:flutter/material.dart';
import 'package:time_manager/core/constants/app_colors.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/domain/entities/planning/planning.dart';
import 'package:time_manager/l10n/app_localizations.dart';

class PlanningListWidget extends StatelessWidget {
  final List<Planning> plannings;
  final ColorScheme colorScheme;
  final Function(Planning) onEdit;
  final Function(Planning) onDelete;
  final AppLocalizations? tr;

  const PlanningListWidget({
    super.key,
    required this.plannings,
    required this.colorScheme,
    required this.onEdit,
    required this.onDelete,
    this.tr,
  });

  @override
  Widget build(BuildContext context) {
    final translations = tr ?? AppLocalizations.of(context)!;
    final sortedPlannings = List<Planning>.from(plannings)
      ..sort((a, b) => a.weekDay.compareTo(b.weekDay));

    return Column(
      children: sortedPlannings.map((planning) {
        return _PlanningCard(
          planning: planning,
          colorScheme: colorScheme,
          onEdit: () => onEdit(planning),
          onDelete: () => onDelete(planning),
          tr: translations,
        );
      }).toList(),
    );
  }
}

class _PlanningCard extends StatelessWidget {
  final Planning planning;
  final ColorScheme colorScheme;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final AppLocalizations tr;

  const _PlanningCard({
    required this.planning,
    required this.colorScheme,
    required this.onEdit,
    required this.onDelete,
    required this.tr,
  });

  @override
  Widget build(BuildContext context) {
    final weekDayName = _getWeekDayName(planning.weekDay);
    final weekDayColor = _getWeekDayColor(planning.weekDay);

    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.p16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.r16),
        border: Border.all(
          color: weekDayColor.withValues(alpha:0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha:0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(weekDayName, weekDayColor),
          _buildTimeInfo(),
          _buildDuration(),
        ],
      ),
    );
  }

  Widget _buildHeader(String weekDayName, Color weekDayColor) {
    return Container(
      padding: EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            weekDayColor.withValues(alpha:0.2),
            weekDayColor.withValues(alpha:0.1),
          ],
        ),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(14),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSizes.p12),
            decoration: BoxDecoration(
              color: weekDayColor.withValues(alpha:0.3),
              borderRadius: BorderRadius.circular(AppSizes.r12),
            ),
            child: Icon(
              Icons.calendar_today,
              color: weekDayColor,
              size: 20,
            ),
          ),
          SizedBox(width: AppSizes.p12),
          Expanded(
            child: Text(
              weekDayName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: weekDayColor,
              ),
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: Icon(
              Icons.edit_outlined,
              color: colorScheme.primary,
            ),
            tooltip: tr.edit,
          ),
          IconButton(
            onPressed: onDelete,
            icon: Icon(
              Icons.delete_outline,
              color: AppColors.error,
            ),
            tooltip: tr.delete,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInfo() {
    return Padding(
      padding: EdgeInsets.all(AppSizes.p16),
      child: Row(
        children: [
          Expanded(
            child: _buildTimeCard(
              tr.arrival,
              planning.startTime,
              Icons.login_rounded,
              AppColors.success,
            ),
          ),
          SizedBox(width: AppSizes.p16),
          Expanded(
            child: _buildTimeCard(
              tr.departure,
              planning.endTime,
              Icons.logout_rounded,
              AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeCard(
    String label,
    String time,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(AppSizes.r12),
        border: Border.all(
          color: color.withValues(alpha:0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          SizedBox(height: AppSizes.p8),
          Text(
            label,
            style: TextStyle(
              fontSize: AppSizes.textSm,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: AppSizes.p4),
          Text(
            time.substring(0, 5), // HH:mm
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDuration() {
    return Container(
      padding: EdgeInsets.all(AppSizes.p12),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha:0.3),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(14),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timer_outlined,
            size: 18,
            color: colorScheme.primary,
          ),
          SizedBox(width: AppSizes.p8),
          Text(
            '${tr.duration}: ${_calculateDuration(planning.startTime, planning.endTime)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  String _calculateDuration(String start, String end) {
    try {
      final startParts = start.split(':');
      final endParts = end.split(':');

      final startMinutes = int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
      final endMinutes = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);

      final durationMinutes = endMinutes - startMinutes;
      final hours = durationMinutes ~/ 60;
      final minutes = durationMinutes % 60;

      if (minutes == 0) {
        return '${hours}h';
      }
      return '${hours}h${minutes.toString().padLeft(2, '0')}';
    } catch (e) {
      return '-';
    }
  }

  String _getWeekDayName(int weekDay) {
    final days = [
      tr.monday,
      tr.tuesday,
      tr.wednesday,
      tr.thursday,
      tr.friday,
    ];
    return days[weekDay];
  }

  Color _getWeekDayColor(int weekDay) {
    const colors = [
      AppColors.primary,    // Lundi
      AppColors.success,    // Mardi
      AppColors.warning,    // Mercredi
      Colors.purple,        // Jeudi
      Colors.teal,          // Vendredi
    ];
    return colors[weekDay % colors.length];
  }
}