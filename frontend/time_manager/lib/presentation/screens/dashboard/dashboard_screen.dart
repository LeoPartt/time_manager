// 📁 lib/presentation/screens/dashboard_screen.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/core/utils/accessibility_utils.dart';
import 'package:time_manager/core/utils/extensions/context_extensions.dart';
import 'package:time_manager/core/widgets/app_button.dart';
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
import 'package:time_manager/presentation/screens/dashboard/widgets/team_selector.dart';
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
  ReportPeriod _selectedPeriod = ReportPeriod.year;

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

    if (widget.userId != null) {
      cubit.loadUserReport(context, widget.userId!);
      return;
    }

    final userState = context.read<UserCubit>().state;

    userState.when(
      loaded: (user) {
        cubit.loadUserReport(context, user.id);
      },
      initial: () {},
      loading: () {},
      error: (msg) {
        context.showSnack("⚠️ $msg", isError: true);
      },
      updated: (user) {
        cubit.loadUserReport(context, user.id);
      },
      deleted: () {},
      listLoaded: (_) {},
    );
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
                            context.read<DashboardCubit>().loadUserReport(context, user.id);
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
                                    tr.loadingProfile,
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
                                    tr.dashboardLoading,
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                            loaded: (report) => _buildDashboardContent(
                              context,
                              report,
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

 Widget _buildDashboardContent(
  BuildContext context,
  report,
  ColorScheme colorScheme,
) {
  final tr = AppLocalizations.of(context)!;
  return Column(
    children: [
      // Sélecteur de période
      _buildPeriodSelector(context, colorScheme),
      SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p24)),

      // Chart Attendance/Punctuality
      AttendanceChart(
        punctualityRate: _getRateForPeriod(report.punctualityRates),
        attendanceRate: _getRateForPeriod(report.attendanceRates),
        period: _getPeriodLabel(),
      ),

      SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p24)),

      // ✅ Work Chart dynamique selon la période
      _buildWorkChartForPeriod(
        context,
        report.workAverages,
        colorScheme,
      ),

      SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p24)),

      // Boutons navigation
      Row(
        children: [
          Expanded(
            child: AccessibilityUtils.withTooltip(
              context,
              tooltip: tr.calendar,
              child: AppButton(
                label: tr.calendar,
                fullSize: true,
                onPressed: () => context.pushRoute(
                  PlanningCalendarRoute(),
                ),
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
            child: AccessibilityUtils.withTooltip(
              context,
              tooltip: tr.team,
              child: AppButton(
                label: tr.team,
                fullSize: true,
                onPressed: () => context.pushRoute(
                  TeamDashboardRoute(),
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

// ✅ Nouveau: Sélectionne le bon chart selon la période
Widget _buildWorkChartForPeriod(
  BuildContext context,
  dynamic workAverages,
  ColorScheme colorScheme,
) {
  switch (_selectedPeriod) {
    case ReportPeriod.week:
      return WeeklyWorkChart(
        totalHours: workAverages.weekly,
      );
    case ReportPeriod.month:
      return MonthlyWorkChart(
        totalHours: workAverages.monthly,
      );
    case ReportPeriod.year:
      return YearlyWorkChart(
        totalHours: workAverages.yearly,
      );
  }
}

  Widget _buildPeriodSelector(BuildContext context, ColorScheme colorScheme) {
    final tr = AppLocalizations.of(context)!;
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
              tr.week,
              ReportPeriod.week,
              colorScheme,
            ),
          ),
          Expanded(
            child: _buildPeriodButton(
              context,
              tr.month,
              ReportPeriod.month,
              colorScheme,
            ),
          ),
          Expanded(
            child: _buildPeriodButton(
              context,
              tr.year,
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

  Widget _buildWorkCard(
    BuildContext context,
    String period,
    double hours,
    ColorScheme colorScheme,
  ) {
    final tr = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.responsiveWidth(context, AppSizes.p20)),
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
            '${tr.work} $period',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p12)),
          Text(
            '${hours.toStringAsFixed(1)} ${tr.hours}',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  // Helpers pour extraire les bonnes données selon la période
  double _getRateForPeriod(dynamic reportRates) {
    switch (_selectedPeriod) {
      case ReportPeriod.week:
        return reportRates.weekly;
      case ReportPeriod.month:
        return reportRates.monthly;
      case ReportPeriod.year:
        return reportRates.yearly;
    }
  }

  double _getWorkAverageForPeriod(dynamic workAverages) {
    switch (_selectedPeriod) {
      case ReportPeriod.week:
        return workAverages.weekly;
      case ReportPeriod.month:
        return workAverages.monthly;
      case ReportPeriod.year:
        return workAverages.yearly;
    }
  }

  String _getPeriodLabel() {
    final tr = AppLocalizations.of(context)!;
    switch (_selectedPeriod) {
      case ReportPeriod.week:
        return tr.weekly;
      case ReportPeriod.month:
        return tr.monthly;
      case ReportPeriod.year:
        return tr.yearly;
    }
  }
}