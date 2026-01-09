// 📁 lib/presentation/screens/dashboard_screen.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/core/utils/extensions/context_extensions.dart';
import 'package:time_manager/core/widgets/app_button.dart';
import 'package:time_manager/domain/entities/dashboard_report.dart';
import 'package:time_manager/initialization/locator.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/cubits/dashboard/dashboard_cubit.dart';
import 'package:time_manager/presentation/cubits/dashboard/dashboard_state.dart';
import 'package:time_manager/presentation/cubits/user/user_cubit.dart';
import 'package:time_manager/presentation/cubits/user/user_state.dart';
import 'package:time_manager/presentation/routes/app_router.dart';
import 'package:time_manager/presentation/screens/dashboard/widgets/charts/monthly_work_chart.dart';
import 'package:time_manager/presentation/screens/dashboard/widgets/charts/weekly_work_chart.dart';
import 'package:time_manager/presentation/screens/dashboard/widgets/charts/yearly_work_chart.dart';
import 'package:time_manager/presentation/screens/dashboard/widgets/charts/attendance_chart.dart';
import 'package:time_manager/presentation/widgets/header.dart';
import 'package:time_manager/presentation/widgets/navbar.dart';

enum ReportPeriod { week, month, year }

@RoutePage()
class DashboardScreen extends StatelessWidget {
  final int? userId;

  const DashboardScreen({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<DashboardCubit>(),
      child: _DashboardView(userId: userId),
    );
  }
}

class _DashboardView extends StatefulWidget {
  final int? userId;

  const _DashboardView({this.userId});

  @override
  State<_DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<_DashboardView> {
  ReportPeriod _selectedPeriod = ReportPeriod.week;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadDashboard();
      }
    });
  }

  void _loadDashboard() {
    final cubit = context.read<DashboardCubit>();
    final mode = _getModeString(_selectedPeriod);

    if (widget.userId != null) {
      cubit.loadUserDashboard(
        context,
        userId: widget.userId!,
        mode: mode,
      );
      return;
    }

    final userState = context.read<UserCubit>().state;

    userState.when(
      loaded: (user) {
        cubit.loadUserDashboard(
          context,
          userId: user.id,
          mode: mode,
        );
      },
      initial: () {},
      loading: () {},
      error: (msg) {
        context.showSnack("⚠️ $msg", isError: true);
      },
      updated: (user) {
        cubit.loadUserDashboard(
          context,
          userId: user.id,
          mode: mode,
        );
      },
      deleted: () {},
      listLoaded: (_) {},
    );
  }

  String _getModeString(ReportPeriod period) {
    switch (period) {
      case ReportPeriod.week:
        return 'w';
      case ReportPeriod.month:
        return 'm';
      case ReportPeriod.year:
        return 'y';
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      bottomNavigationBar: const NavBar(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _loadDashboard();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(AppSizes.responsiveWidth(context, AppSizes.p24)),
            child: Column(
              children: [
                Header(label: tr.dashboard),
                SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p24)),

                BlocListener<UserCubit, UserState>(
                  listener: (context, userState) {
                    userState.whenOrNull(
                      loaded: (user) {
                        if (widget.userId == null) {
                          final dashboardState = context.read<DashboardCubit>().state;

                          if (dashboardState is Initial) {
                            final mode = _getModeString(_selectedPeriod);
                            context.read<DashboardCubit>().loadUserDashboard(
                              context,
                              userId: user.id,
                              mode: mode,
                            );
                          }
                        }
                      },
                    );
                  },
                  child: BlocBuilder<UserCubit, UserState>(
                    builder: (context, userState) {
                      return BlocBuilder<DashboardCubit, DashboardState>(
                        builder: (context, dashboardState) {
                          if (userState is UserLoading && dashboardState is Initial) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Chargement de votre profil...',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            );
                          }

                          return dashboardState.when(
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
                                    'Chargement du dashboard...',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                            userLoaded: (report) => _buildDashboardContent(
                              context,
                              report.dashboard,
                              colorScheme,
                            ),
                            teamLoaded: (_) => const SizedBox(),
                            globalLoaded: (_) => const SizedBox(),
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
                                        'Erreur',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.error,
                                        ),
                                      ),
                                      SizedBox(height: AppSizes.p8),
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade50,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Colors.red.shade200),
                                        ),
                                        child: SelectableText(
                                          msg,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'monospace',
                                            color: Colors.red.shade900,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: AppSizes.p16),
                                      ElevatedButton.icon(
                                        onPressed: _loadDashboard,
                                        icon: const Icon(Icons.refresh),
                                        label: const Text('Réessayer'),
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

  Widget _buildDashboardContent(
    BuildContext context,
    DashboardReport report,
    ColorScheme colorScheme,
  ) {
    return Column(
      children: [
        // ✅ Sélecteur de période
        _buildPeriodSelector(context, colorScheme),
        SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p24)),

        // ✅ Chart Attendance/Punctuality
        AttendanceChart(
          punctuality: report.punctuality,
          attendance: report.attendance,
          period: _getPeriodLabel(),
        ),

        SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p24)),

        // ✅ Work Chart dynamique selon la période
        _buildWorkChartForPeriod(context, report.work, colorScheme),

        SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p24)),

        // Boutons navigation
        Row(
          children: [
            Expanded(
              child: AppButton(
                label: "Calendar",
                fullSize: true,
                onPressed: () => context.pushRoute(
                  PlanningCalendarRoute(),
                ),
              ),
            ),
            SizedBox(
              width: AppSizes.responsiveWidth(
                context,
                AppSizes.p16,
              ),
            ),
            Expanded(
              child: AppButton(
                label: "Team",
                fullSize: true,
                onPressed: () => context.pushRoute(
                  TeamDashboardRoute(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPeriodSelector(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(AppSizes.p4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSizes.r12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildPeriodButton(
              context,
              'Semaine',
              ReportPeriod.week,
              colorScheme,
            ),
          ),
          Expanded(
            child: _buildPeriodButton(
              context,
              'Mois',
              ReportPeriod.month,
              colorScheme,
            ),
          ),
          Expanded(
            child: _buildPeriodButton(
              context,
              'Année',
              ReportPeriod.year,
              colorScheme,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(
    BuildContext context,
    String label,
    ReportPeriod period,
    ColorScheme colorScheme,
  ) {
    final isSelected = _selectedPeriod == period;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPeriod = period;
        });
        _loadDashboard();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppSizes.p12,
          horizontal: AppSizes.p16,
        ),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSizes.r8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildWorkChartForPeriod(
    BuildContext context,
    WorkSeries workSeries,
    ColorScheme colorScheme,
  ) {
    switch (_selectedPeriod) {
      case ReportPeriod.week:
        return WeeklyWorkChart(workSeries: workSeries);
      case ReportPeriod.month:
        return MonthlyWorkChart(workSeries: workSeries);
      case ReportPeriod.year:
        return YearlyWorkChart(workSeries: workSeries);
    }
  }

  String _getPeriodLabel() {
    switch (_selectedPeriod) {
      case ReportPeriod.week:
        return 'Hebdomadaire';
      case ReportPeriod.month:
        return 'Mensuel';
      case ReportPeriod.year:
        return 'Annuel';
    }
  }
}