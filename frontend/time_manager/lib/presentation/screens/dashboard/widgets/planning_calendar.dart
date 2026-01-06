
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_manager/core/constants/app_sizes.dart';

class PlanningCalendar extends StatefulWidget {
  const PlanningCalendar({super.key});

  @override
  State<PlanningCalendar> createState() => _PlanningCalendarState();
}

class _PlanningCalendarState extends State<PlanningCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // TODO: Récupérer depuis une API
  final Map<DateTime, List<String>> _events = {
    DateTime.utc(2026, 1, 6): ['9:30 - 17:45'],
    DateTime.utc(2026, 1, 7): ['10:00 - 18:00'],
    DateTime.utc(2026, 1, 8): ['9:00 - 17:30'],
  };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.r16),
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        eventLoader: (day) => _events[day] ?? [],
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.5),
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
        ),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
      ),
    );
  }
}