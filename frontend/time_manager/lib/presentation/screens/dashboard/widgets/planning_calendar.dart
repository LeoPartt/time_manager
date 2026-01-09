// 📁 lib/presentation/screens/planning_calendar_screen.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/initialization/locator.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/cubits/planning/planning_cubit.dart';
import 'package:time_manager/presentation/cubits/planning/planning_state.dart';

import 'package:time_manager/presentation/cubits/user/user_cubit.dart';
import 'package:time_manager/presentation/cubits/user/user_state.dart';
import 'package:time_manager/presentation/widgets/header.dart';
import 'package:time_manager/presentation/widgets/navbar.dart';

@RoutePage()
class PlanningCalendarScreen extends StatelessWidget {
  final int? userId; // null = utilisateur connecté, sinon userId spécifique

  const PlanningCalendarScreen({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<PlanningCubit>(),
      child: _PlanningCalendarView(userId: userId),
    );
  }
}

class _PlanningCalendarView extends StatefulWidget {
  final int? userId;

  const _PlanningCalendarView({this.userId});

  @override
  State<_PlanningCalendarView> createState() => _PlanningCalendarViewState();
}

class _PlanningCalendarViewState extends State<_PlanningCalendarView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadPlannings();
      }
    });
  }

  void _loadPlannings() {
    final cubit = context.read<PlanningCubit>();

    if (widget.userId != null) {
      cubit.loadUserPlannings(context, widget.userId!);
      return;
    }

    final userState = context.read<UserCubit>().state;
    userState.whenOrNull(
      loaded: (user) => cubit.loadUserPlannings(context, user.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.planningCalendar),
        backgroundColor: colorScheme.primary,
      ),
      bottomNavigationBar: const NavBar(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _loadPlannings();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(AppSizes.responsiveWidth(context, AppSizes.p24)),
            child: Column(
              children: [
                Header(label: tr.planning),
                SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p24)),

                // Écoute UserCubit pour charger automatiquement
                BlocListener<UserCubit, UserState>(
                  listener: (context, userState) {
                    userState.whenOrNull(
                      loaded: (user) {
                        if (widget.userId == null) {
                          final planningState = context.read<PlanningCubit>().state;
                          if (planningState is Initial) {
                            context.read<PlanningCubit>().loadUserPlannings(context, user.id);
                          }
                        }
                      },
                    );
                  },
                  child: BlocBuilder<UserCubit, UserState>(
                    builder: (context, userState) {
                      return BlocBuilder<PlanningCubit, PlanningState>(
                        builder: (context, planningState) {
                          // UserCubit loading
                          if (userState is UserLoading && planningState is Initial) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(),
                                  const SizedBox(height: 16),
                                  Text(
                                    tr.loadingProfile,
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            );
                          }

                          return planningState.when(
                            initial: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            loading: () => Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(),
                                  const SizedBox(height: 16),
                                  Text(
                                    tr.planningLoading,
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                            loaded: (plannings) => _buildCalendar(
                              context,
                              plannings,
                              colorScheme,
                            ),
                            error: (msg) => Center(
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        size: 64,
                                        color: colorScheme.error,
                                      ),
                                      SizedBox(height: AppSizes.p16),
                                      Text(
                                        tr.error,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.error,
                                        ),
                                      ),
                                      SizedBox(height: AppSizes.p8),
                                      Text(
                                        msg,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.grey[600]),
                                      ),
                                      SizedBox(height: AppSizes.p16),
                                      ElevatedButton.icon(
                                        onPressed: _loadPlannings,
                                        icon: const Icon(Icons.refresh),
                                        label: Text(tr.retry),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar(
    BuildContext context,
    List<dynamic> plannings,
    ColorScheme colorScheme,
  ) {
    // Convertir les plannings en events pour le calendrier
    final events = _planningsToEvents(plannings);

    return Column(
      children: [
        // Calendrier
        Container(
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
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: (day) {
              // Récupère les horaires pour ce jour de la semaine
              final weekday = day.weekday;
              return events[weekday] ?? [];
            },
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
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
          ),
        ),

        SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p24)),

        // Détails du jour sélectionné
        if (_selectedDay != null)
          _buildDayDetails(context, _selectedDay!, events, colorScheme),

        SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p24)),

        // Liste des plannings hebdomadaires
        _buildWeeklySchedule(context, plannings, colorScheme),
      ],
    );
  }

  Widget _buildDayDetails(
    BuildContext context,
    DateTime day,
    Map<int, List<String>> events,
    ColorScheme colorScheme,
  ) {
    final weekday = day.weekday;
    final schedules = events[weekday];
    final tr = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.p20),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppSizes.r16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.event, color: colorScheme.onPrimaryContainer),
              SizedBox(width: AppSizes.p8),
              Text(
                _formatDate(day),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.p12),
          if (schedules != null && schedules.isNotEmpty)
            ...schedules.map((schedule) => Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSizes.p4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: colorScheme.onPrimaryContainer,
                      ),
                      SizedBox(width: AppSizes.p8),
                      Text(
                        schedule,
                        style: TextStyle(
                          fontSize: 16,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ))
          else
            Text(
              tr.noPlanningForToday,
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: colorScheme.onPrimaryContainer.withOpacity(0.7),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWeeklySchedule(
    BuildContext context,
    List<dynamic> plannings,
    ColorScheme colorScheme,
  ) {
    final tr = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.p20),
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
          Text(
            tr.planningWeekly,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: AppSizes.p16),
          if (plannings.isEmpty)
            Center(
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
                      tr.noConfigPlanning,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...plannings.map((planning) => _buildPlanningItem(
                  context,
                  planning,
                  colorScheme,
                )),
        ],
      ),
    );
  }

  Widget _buildPlanningItem(
    BuildContext context,
    dynamic planning,
    ColorScheme colorScheme,
  ) {
    final weekDayName = _getWeekDayName(planning.weekDay);
    final startTime = _formatTime(planning.startTime);
    final endTime = _formatTime(planning.endTime);

    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.p12),
      padding: EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppSizes.r12),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.3),
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

  // Helpers
  Map<int, List<String>> _planningsToEvents(List<dynamic> plannings) {
    final Map<int, List<String>> events = {};

    for (var planning in plannings) {
      final weekday = planning.weekDay + 1; // Backend: 0=Monday, Calendar: 1=Monday
      final startTime = _formatTime(planning.startTime);
      final endTime = _formatTime(planning.endTime);
      final schedule = '$startTime - $endTime';

      events[weekday] = events[weekday] ?? [];
      events[weekday]!.add(schedule);
    }

    return events;
  }

  String _getWeekDayName(int weekDay) {
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
    return days[weekDay];
  }

  String _formatTime(dynamic time) {
    if (time is String) {
      // Format: "HH:mm" ou "HH:mm:ss"
      return time.substring(0, 5);
    }
    return time.toString();
  }

  String _formatDate(DateTime date) {
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