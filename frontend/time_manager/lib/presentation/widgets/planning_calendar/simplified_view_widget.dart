
import 'package:flutter/material.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/domain/entities/schedule/daily_work.dart';

class SimplifiedViewWidget extends StatelessWidget {
  final DailyWork dailyWork;
  final ColorScheme colorScheme;
  final VoidCallback onToggleDetailedView;

  const SimplifiedViewWidget({
    super.key,
    required this.dailyWork,
    required this.colorScheme,
    required this.onToggleDetailedView,
  });

  @override
  Widget build(BuildContext context) {
    final firstClockIn = dailyWork.workPeriods.first.clockIn;
    final lastPeriod = dailyWork.workPeriods.last;
    final lastClockOut = lastPeriod.clockOut;

    final isStillWorking = lastClockOut == null;
    final statusColor = isStillWorking ? Colors.blue : Colors.green;

    return Column(
      children: [
        // Carte principale avec premier IN → dernier OUT
        _buildScheduleRow(
          context,
          '✅ Travail réel',
          _formatSimplifiedTime(firstClockIn, lastClockOut),
          '${dailyWork.summary.totalHours.toStringAsFixed(2)}h',
          statusColor,
        ),

        SizedBox(height: AppSizes.p12),

        // Info sur le nombre de périodes (CLIQUABLE)
        if (dailyWork.workPeriods.length > 1)
          _buildPeriodsInfoCard(context),

        // Variance
        if (dailyWork.summary.varianceHours != null) ...[
          SizedBox(height: AppSizes.p12),
          _buildVarianceCard(context, dailyWork.summary.varianceHours!),
        ],

        // Statut
        SizedBox(height: AppSizes.p12),
        _buildStatusBadge(context, dailyWork.summary.dayStatus, statusColor),
      ],
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
        color: color.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(AppSizes.r12),
        border: Border.all(color: color.withValues(alpha:0.3)),
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

  Widget _buildPeriodsInfoCard(BuildContext context) {
    return InkWell(
      onTap: onToggleDetailedView,
      borderRadius: BorderRadius.circular(AppSizes.r8),
      child: Container(
        padding: EdgeInsets.all(AppSizes.p12),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(AppSizes.r8),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, size: 18, color: Colors.blue),
            SizedBox(width: AppSizes.p12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${dailyWork.workPeriods.length} périodes de travail',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Appuyez pour voir les détails',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.blue,
              size: 24,
            ),
          ],
        ),
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

  Widget _buildStatusBadge(BuildContext context, DayStatus status, Color color) {
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

  String _formatSimplifiedTime(DateTime firstIn, DateTime? lastOut) {
    String formatter(DateTime dt) =>
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

    if (lastOut != null) {
      return '${formatter(firstIn.toLocal())} - ${formatter(lastOut.toLocal())}';
    }
    return '${formatter(firstIn.toLocal())} - En cours';
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