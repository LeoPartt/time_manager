

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/core/utils/extensions/context_extensions.dart';
import 'package:time_manager/domain/entities/schedule/daily_work.dart';
import 'package:time_manager/domain/usecases/schedule/get_daily_work.dart';
import 'package:time_manager/initialization/locator.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/cubits/planning/planning_cubit.dart';
import 'package:time_manager/presentation/cubits/planning/planning_state.dart';
import 'package:time_manager/presentation/cubits/user/user_cubit.dart';
import 'package:time_manager/presentation/cubits/user/user_state.dart';
import 'package:time_manager/presentation/widgets/header.dart';
import 'package:time_manager/presentation/widgets/navbar.dart';
import 'package:time_manager/presentation/widgets/planning_calendar/calendar_widget.dart';
import 'package:time_manager/presentation/widgets/planning_calendar/day_details_widget.dart';
import 'package:time_manager/presentation/widgets/planning_calendar/weekly_schedule_widget.dart';

@RoutePage()
class PlanningCalendarScreen extends StatelessWidget {
  final int? userId;

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
  DailyWork? _selectedDayWork;
  bool _loadingDayWork = false;
  bool _showDetailedPeriods = false;

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

  Future<void> _loadDayWork(DateTime day) async {
    setState(() {
      _loadingDayWork = true;
      _selectedDayWork = null;
    });

    try {
      final userId = _getUserId();
      if (userId == null) return;

      final getDailyWork = locator<GetDailyWork>();
      final dailyWork = await getDailyWork(userId: userId, date: day);

      if (mounted) {
        setState(() {
          _selectedDayWork = dailyWork;
          _loadingDayWork = false;
        });
      }
    } catch (e) {
    
      if (mounted) {
        setState(() {
          _selectedDayWork = null;
          _loadingDayWork = false;
        });
      }
    }
  }

  int? _getUserId() {
    if (widget.userId != null) {
      return widget.userId;
    }

    final userState = context.read<UserCubit>().state;
    if (userState is UserLoaded) {
      return userState.user.id;
    }

    return null;
  }

  void _toggleDetailedView() {
    setState(() {
      _showDetailedPeriods = !_showDetailedPeriods;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
     final tr = AppLocalizations.of(context)!;
     final isTablet = context.screenWidth >= 600;
    return Scaffold(
      
     
      bottomNavigationBar: const NavBar(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _loadPlannings();
            if (_selectedDay != null) {
              await _loadDayWork(_selectedDay!);
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(AppSizes.responsiveWidth(context, AppSizes.p24)),
            child:  Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isTablet ? 900 : double.infinity,
                ),
                child: Column(
                  children: [
                    _buildHeader(context, tr),
                    SizedBox(height: AppSizes.p24),
                    _buildContent(context, colorScheme),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ColorScheme colorScheme) {
    final tr = AppLocalizations.of(context)!;
    return BlocListener<UserCubit, UserState>(
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
              if (userState is UserLoading && planningState is Initial) {
                return _buildLoadingState(tr.loadingProfile);
              }

              return planningState.when(
                initial: () => _buildLoadingState(tr.initializing),
                loading: () => _buildLoadingState(tr.loadingPlanning),
                loaded: (plannings) => _buildCalendarView(context, plannings, colorScheme),
                error: (msg) => _buildErrorState(context, msg, colorScheme),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLoadingState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(message, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }
 Widget _buildHeader(BuildContext context, AppLocalizations tr) {
    
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return state.maybeWhen(
          loaded: (currentUser) {
           
            return Column(
              children: [
                Header(
                  label: tr.planning,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.router.pop(),
                  ),
                ),
                
              
              ],
            );
          },
          orElse: () => Header(label: tr.planning),
        );
      },
    );
  }
  Widget _buildErrorState(BuildContext context, String msg, ColorScheme colorScheme) {
   final tr = AppLocalizations.of(context)!;
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: colorScheme.error),
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
                label:  Text(tr.retry),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarView(
    BuildContext context,
    List<dynamic> plannings,
    ColorScheme colorScheme,
  ) {
    return Column(
      children: [
        // Calendrier
        CalendarWidget(
          focusedDay: _focusedDay,
          selectedDay: _selectedDay,
          plannings: plannings,
          colorScheme: colorScheme,
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            _loadDayWork(selectedDay);
          },
          onFocusedDayChanged: (focusedDay) {
            setState(() {
              _focusedDay = focusedDay;
            });
          },
        ),

        SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p24)),

        // Détails du jour sélectionné
        if (_selectedDay != null)
          DayDetailsWidget(
            day: _selectedDay!,
            dailyWork: _selectedDayWork,
            isLoading: _loadingDayWork,
            showDetailedPeriods: _showDetailedPeriods,
            onToggleDetailedView: _toggleDetailedView,
            colorScheme: colorScheme,
          ),

        SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p24)),

        // Planning hebdomadaire
        WeeklyScheduleWidget(
          plannings: plannings,
          colorScheme: colorScheme,
        ),
      ],
    );
  }
}