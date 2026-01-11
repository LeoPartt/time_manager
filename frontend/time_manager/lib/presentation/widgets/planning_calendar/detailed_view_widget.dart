// 📁 lib/presentation/widgets/planning_calendar/detailed_view_widget.dart

import 'package:flutter/material.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/domain/entities/schedule/daily_work.dart';

class DetailedViewWidget extends StatelessWidget {
  final DailyWork dailyWork;
  final ColorScheme colorScheme;

  const DetailedViewWidget({
    super.key,
    required this.dailyWork,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header avec total
        _buildHeader(context),
        SizedBox(height: AppSizes.p12),

        // Liste des périodes
        ...dailyWork.workPeriods.asMap().entries.map((entry) {
          final index = entry.key;
          final period = entry.value;
          return _buildWorkPeriodCard(context, period, index + 1);
        }),

        // Variance
        if (dailyWork.summary.varianceHours != null) ...[
          SizedBox(height: AppSizes.p12),
          _buildVarianceCard(context, dailyWork.summary.varianceHours!),
        ],

        // Statut
        SizedBox(height: AppSizes.p12),
        _buildStatusBadge(context, dailyWork.summary.dayStatus),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.p12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withValues(alpha:0.1),
            colorScheme.primary.withValues(alpha:0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.r12),
        border: Border.all(color: colorScheme.primary.withValues(alpha:0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '✅ Travail réel',
            style: TextStyle(
              fontSize: 14,
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
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(AppSizes.r8),
            ),
            child: Text(
              '${dailyWork.summary.totalHours.toStringAsFixed(2)}h',
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

  Widget _buildWorkPeriodCard(BuildContext context, WorkPeriod period, int index) {
    final isCompleted = period.status == WorkStatus.completed;
    final periodColor = isCompleted ? Colors.green : Colors.blue;

    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.p8),
      padding: EdgeInsets.all(AppSizes.p12),
      decoration: BoxDecoration(
        color: periodColor.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(AppSizes.r8),
        border: Border.all(color: periodColor.withValues(alpha:0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: periodColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$index',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          SizedBox(width: AppSizes.p12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatPeriodTime(period),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: periodColor,
                  ),
                ),
                if (isCompleted)
                  Text(
                    'Durée : ${period.durationHours.toStringAsFixed(2)}h',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
          Icon(
            isCompleted ? Icons.check_circle : Icons.access_time,
            color: periodColor,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildVarianceCard(BuildContext context, double varianceHours) {
    final isPositive = varianceHours >= 0;
    final color = isPositive ? Colors.green : Colors.orange;

    return Container(
      padding: EdgeInsets.all(AppSizes.p12),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(AppSizes.r12),
        border: Border.all(color: color.withValues(alpha:0.3)),
      ),
      child: Row(
        children: [
          Icon(
            isPositive ? Icons.trending_up : Icons.trending_down,
            color: color,
          ),
          SizedBox(width: AppSizes.p12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '⏱️ Écart par rapport au planning',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: AppSizes.p4),
                Text(
                  '${isPositive ? '+' : ''}${varianceHours.toStringAsFixed(2)}h',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, DayStatus status) {
    final color = _getStatusColor(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.p12,
        vertical: AppSizes.p8,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(AppSizes.r8),
        border: Border.all(color: color.withValues(alpha:0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getStatusIcon(status), color: color, size: 16),
          SizedBox(width: AppSizes.p8),
          Text(
            _getStatusText(status),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _formatPeriodTime(WorkPeriod period) {
    String formatter(DateTime dt) =>
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

    if (period.clockOut != null) {
      return '${formatter(period.clockIn.toLocal())} - ${formatter(period.clockOut!.toLocal())}';
    }
    return '${formatter(period.clockIn.toLocal())} - En cours';
  }

  Color _getStatusColor(DayStatus status) {
    switch (status) {
      case DayStatus.completed:
        return Colors.green;
      case DayStatus.inProgress:
        return Colors.blue;
      case DayStatus.absent:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(DayStatus status) {
    switch (status) {
      case DayStatus.completed:
        return Icons.check_circle;
      case DayStatus.inProgress:
        return Icons.access_time;
      case DayStatus.absent:
        return Icons.event_busy;
    }
  }

  String _getStatusText(DayStatus status) {
    switch (status) {
      case DayStatus.completed:
        return 'Journée terminée';
      case DayStatus.inProgress:
        return 'En cours';
      case DayStatus.absent:
        return 'Aucun pointage';
    }
  }
}