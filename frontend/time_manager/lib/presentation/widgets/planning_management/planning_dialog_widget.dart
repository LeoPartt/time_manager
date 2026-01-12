
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/core/constants/app_colors.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/core/utils/extensions/context_extensions.dart';
import 'package:time_manager/domain/entities/planning/planning.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/cubits/planning/planning_cubit.dart';

class PlanningDialogWidget extends StatefulWidget {
  final int userId;
  final Planning? planning;
  final AppLocalizations? tr;

  const PlanningDialogWidget({
    super.key,
    required this.userId,
    this.planning,
    this.tr,
  });

  @override
  State<PlanningDialogWidget> createState() => _PlanningDialogWidgetState();
}

class _PlanningDialogWidgetState extends State<PlanningDialogWidget> {
  int _selectedWeekDay = 0;
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 17, minute: 30);

  @override
  void initState() {
    super.initState();
    if (widget.planning != null) {
      _selectedWeekDay = widget.planning!.weekDay;
      _startTime = _parseTime(widget.planning!.startTime);
      _endTime = _parseTime(widget.planning!.endTime);
    }
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final tr = widget.tr ?? AppLocalizations.of(context)!;
    final colorScheme = context.colorScheme;
    final isEdit = widget.planning != null;
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.r16),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(AppSizes.p20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.primary.withValues(alpha:0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppSizes.r16),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(AppSizes.p12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha:0.2),
                        borderRadius: BorderRadius.circular(AppSizes.r12),
                      ),
                      child: Icon(
                        isEdit ? Icons.edit : Icons.add,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: AppSizes.p12),
                    Expanded(
                      child: Text(
                        isEdit ? tr.editPlanning : tr.addPlanning,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: EdgeInsets.all(AppSizes.p20),
                child: Column(
                  children: [
                    _buildWeekDaySelector(context, tr, colorScheme),
                    SizedBox(height: AppSizes.p20),
                    _buildTimeSelector(
                      context,
                      label: tr.arrivalTime,
                      icon: Icons.login_rounded,
                      color: AppColors.success,
                      time: _startTime,
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: _startTime,
                          helpText: tr.selectArrivalTime,
                        );
                        if (time != null) {
                          setState(() => _startTime = time);
                        }
                      },
                    ),
                    SizedBox(height: AppSizes.p16),
                    _buildTimeSelector(
                      context,
                      label: tr.departureTime,
                      icon: Icons.logout_rounded,
                      color: AppColors.warning,
                      time: _endTime,
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: _endTime,
                          helpText: tr.selectDepartureTime,
                        );
                        if (time != null) {
                          setState(() => _endTime = time);
                        }
                      },
                    ),
                    SizedBox(height: AppSizes.p20),
                    _buildDurationPreview(context, tr, colorScheme),
                  ],
                ),
              ),

              // Actions
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSizes.p20,
                  0,
                  AppSizes.p20,
                  AppSizes.p20,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: AppSizes.p16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSizes.r12),
                          ),
                        ),
                        child: Text(tr.cancel),
                      ),
                    ),
                    SizedBox(width: AppSizes.p12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _handleSave(context, isEdit, tr),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: AppSizes.p16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSizes.r12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(isEdit ? tr.save : tr.create),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeekDaySelector(
    BuildContext context,
    AppLocalizations tr,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSizes.r12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha:0.2),
        ),
      ),
      child: DropdownButtonFormField<int>(
        initialValue: _selectedWeekDay,
        decoration: InputDecoration(
          labelText: tr.weekDay,
          prefixIcon: Icon(
            Icons.calendar_today,
            color: colorScheme.primary,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        items: List.generate(5, (index) {
          return DropdownMenuItem(
            value: index,
            child: Text(_getWeekDayName(index, tr)),
          );
        }),
        onChanged: (value) {
          if (value != null) {
            setState(() => _selectedWeekDay = value);
          }
        },
      ),
    );
  }

  Widget _buildTimeSelector(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.r12),
      child: Container(
        padding: EdgeInsets.all(AppSizes.p16),
        decoration: BoxDecoration(
          color: color.withValues(alpha:0.1),
          borderRadius: BorderRadius.circular(AppSizes.r12),
          border: Border.all(color: color.withValues(alpha:0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppSizes.p12),
              decoration: BoxDecoration(
                color: color.withValues(alpha:0.2),
                borderRadius: BorderRadius.circular(AppSizes.r12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            SizedBox(width: AppSizes.p16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                    time.format(context),
                    style: TextStyle(
                      fontSize: AppSizes.textXl,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationPreview(
    BuildContext context,
    AppLocalizations tr,
    ColorScheme colorScheme,
  ) {
    final duration = _calculateDuration();
    final isValid = !duration.contains(tr.invalid);

    return Container(
      padding: EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isValid
              ? [
                  colorScheme.primaryContainer.withValues(alpha:0.5),
                  colorScheme.primaryContainer.withValues(alpha:0.3),
                ]
              : [
                  AppColors.error.withValues(alpha:0.2),
                  AppColors.error.withValues(alpha:0.1),
                ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.r12),
        border: Border.all(
          color: isValid
              ? colorScheme.primary.withValues(alpha:0.3)
              : AppColors.error.withValues(alpha:0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isValid ? Icons.timer_outlined : Icons.error_outline,
            size: 24,
            color: isValid ? colorScheme.primary : AppColors.error,
          ),
          SizedBox(width: AppSizes.p12),
          Column(
            children: [
              Text(
                tr.duration,
                style: TextStyle(
                  fontSize: AppSizes.textSm,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                duration,
                style: TextStyle(
                  fontSize: AppSizes.textXl,
                  fontWeight: FontWeight.bold,
                  color: isValid ? colorScheme.primary : AppColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleSave(BuildContext context, bool isEdit, AppLocalizations tr) {
    final duration = _calculateDuration();
    
    if (duration.contains(tr.invalid)) {
      context.showError(tr.invalidTimeRange);
      return;
    }

    if (isEdit) {
      
      context.read<PlanningCubit>().updatePlanning(
            context,
            userId: widget.userId,
            planningId: widget.planning!.id,
            weekDay: _selectedWeekDay,
            startTime: _formatTimeOfDay(_startTime),
            endTime: _formatTimeOfDay(_endTime),
          );
    } else {
      context.read<PlanningCubit>().createPlanning(
            context,
            userId: widget.userId,
            weekDay: _selectedWeekDay,
            startTime: _formatTimeOfDay(_startTime),
            endTime: _formatTimeOfDay(_endTime),
          );
    }
    
    Navigator.pop(context);
    context.showSuccess(
      isEdit ? tr.planningUpdatedSuccess : tr.planningCreatedSuccess,
    );
  }

  String _calculateDuration() {
    final tr = widget.tr ?? AppLocalizations.of(context)!;
    final startMinutes = _startTime.hour * 60 + _startTime.minute;
    final endMinutes = _endTime.hour * 60 + _endTime.minute;
    final durationMinutes = endMinutes - startMinutes;

    if (durationMinutes < 0) return tr.invalid;

    final hours = durationMinutes ~/ 60;
    final minutes = durationMinutes % 60;

    if (minutes == 0) {
      return '${hours}h';
    }
    return '${hours}h${minutes.toString().padLeft(2, '0')}';
  }

  String _getWeekDayName(int weekDay, AppLocalizations tr) {
    final days = [
      tr.monday,
      tr.tuesday,
      tr.wednesday,
      tr.thursday,
      tr.friday,
    ];
    return days[weekDay];
  }
}