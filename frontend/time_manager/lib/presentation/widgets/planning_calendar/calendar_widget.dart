import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_manager/core/constants/app_sizes.dart';

class CalendarWidget extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final List<dynamic> plannings;
  final ColorScheme colorScheme;
  final Function(DateTime, DateTime) onDaySelected;
  final Function(DateTime)? onFocusedDayChanged;

  const CalendarWidget({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.plannings,
    required this.colorScheme,
    required this.onDaySelected,
    this.onFocusedDayChanged,
  });

  @override
  Widget build(BuildContext context) {
    final events = _planningsToEvents();

    return Container(
      padding: EdgeInsets.all(AppSizes.p16),
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
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: focusedDay,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        
        // ✅ Empêcher la sélection des weekends
        enabledDayPredicate: (day) {
          return day.weekday != DateTime.saturday && 
                 day.weekday != DateTime.sunday;
        },
        
        eventLoader: (day) {
          final weekday = day.weekday;
          return events[weekday] ?? [];
        },
        
        calendarBuilders: CalendarBuilders(
          // Griser les weekends
          defaultBuilder: (context, day, focusedDay) {
            if (_isWeekend(day)) {
              return _buildWeekendDay(day);
            }
            return null;
          },
          outsideBuilder: (context, day, focusedDay) {
            if (_isWeekend(day)) {
              return _buildWeekendDay(day, isOutside: true);
            }
            return null;
          },
          // Désactiver les weekends visuellement
          disabledBuilder: (context, day, focusedDay) {
            if (_isWeekend(day)) {
              return _buildWeekendDay(day, isDisabled: true);
            }
            return null;
          },
        ),
        
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha:0.5),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: colorScheme.primary,
            shape: BoxShape.circle,
          ),
          markerDecoration: BoxDecoration(
            color: colorScheme.secondary,
            shape: BoxShape.circle,
          ),
          markersMaxCount: 1,
          weekendTextStyle: TextStyle(
            color: Colors.grey.shade400,
          ),
        ),
        
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        
        onDaySelected: (selectedDay, focusedDay) {
          // ✅ Ne rien faire si c'est un weekend
          if (_isWeekend(selectedDay)) {
            return;
          }
          onDaySelected(selectedDay, focusedDay);
        },
        
        onPageChanged: onFocusedDayChanged,
      ),
    );
  }

  bool _isWeekend(DateTime day) {
    return day.weekday == DateTime.saturday || day.weekday == DateTime.sunday;
  }

  Widget _buildWeekendDay(DateTime day, {bool isOutside = false, bool isDisabled = false}) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          shape: BoxShape.circle,
        ),
        width: 40,
        height: 40,
        child: Center(
          child: Text(
            '${day.day}',
            style: TextStyle(
              color: isOutside ? Colors.grey.shade400 : Colors.grey.shade500,
              fontWeight: FontWeight.w400,
              decoration: isDisabled ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
      ),
    );
  }

  Map<int, List<String>> _planningsToEvents() {
    final Map<int, List<String>> events = {};

    for (var planning in plannings) {
      final weekday = planning.weekDay + 1;
      final startTime = _formatTime(planning.startTime);
      final endTime = _formatTime(planning.endTime);
      final schedule = '$startTime - $endTime';

      events[weekday] = events[weekday] ?? [];
      events[weekday]!.add(schedule);
    }

    return events;
  }

  String _formatTime(dynamic time) {
    if (time is String) {
      return time.substring(0, 5);
    }
    return time.toString();
  }
}