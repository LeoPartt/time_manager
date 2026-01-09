import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/core/utils/extensions/context_extensions.dart';
import 'package:time_manager/domain/entities/dashboard_report.dart';
import 'package:time_manager/initialization/locator.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/cubits/dashboard/dashboard_cubit.dart';
import 'package:time_manager/presentation/cubits/dashboard/dashboard_state.dart';
import 'package:time_manager/presentation/screens/dashboard/widgets/charts/monthly_work_chart.dart';
import 'package:time_manager/presentation/screens/dashboard/widgets/charts/weekly_work_chart.dart';
import 'package:time_manager/presentation/screens/dashboard/widgets/charts/yearly_work_chart.dart';
import 'package:time_manager/presentation/screens/dashboard/widgets/charts/attendance_chart.dart';
import 'package:time_manager/presentation/widgets/header.dart';
import 'package:time_manager/presentation/widgets/navbar.dart';

enum ReportPeriod { week, month, year }

@RoutePage()
class TeamDashboardScreen extends StatelessWidget {
  const TeamDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<DashboardCubit>(),
      child: const _TeamDashboardView(),
    );
  }
}

class _TeamDashboardView extends StatefulWidget {
  const _TeamDashboardView();

  @override
  State<_TeamDashboardView> createState() => _TeamDashboardViewState();
}

class _TeamDashboardViewState extends State<_TeamDashboardView> {
  int? _selectedTeamId;
  ReportPeriod _selectedPeriod = ReportPeriod.week;

  // TODO: Récupérer la liste des équipes depuis l'API
  final List<Map<String, dynamic>> _teams = [
    {'id': 1, 'name': 'Team Marguerite'},
    {'id': 2, 'name': 'Team Alpha'},
    {'id': 3, 'name': 'Team Beta'},
  ];

  void _loadDashboard() {
    if (_selectedTeamId == null) return;

    final mode = _getModeString(_selectedPeriod);
    context.read<DashboardCubit>().loadTeamDashboard(
      context,
      teamId: _selectedTeamId!,
      mode: mode,
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
    final colorScheme = Theme.of(context).colorScheme;

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
                Header(label: 'Dashboard Team'),
                SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p24)),

                // 🔽 Sélecteur d'équipe
                _buildTeamSelector(colorScheme),
                SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p24)),

                // 📊 Affichage du rapport
                BlocConsumer<DashboardCubit, DashboardState>(
                  listener: (context, state) {
                    state.whenOrNull(
                      error: (msg) => context.showSnack(msg, isError: true),
                    );
                  },
                  builder: (context, state) {
                    return state.when(
                      initial: () => _buildEmptyState(
                        context,
                        colorScheme,
                        'Sélectionnez une équipe',
                        'Choisissez une équipe pour voir son dashboard',
                      ),
                      loading: () => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 16),
                            Text(
                              'Chargement du dashboard...',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      userLoaded: (_) => const SizedBox(),
                      teamLoaded: (report) => _buildDashboardContent(
                        context,
                        report.dashboard,
                        colorScheme,
                      ),
                      globalLoaded: (_) => const SizedBox(),
                      error: (msg) => _buildError(context, msg, colorScheme),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamSelector(ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.p16,
        vertical: AppSizes.p4,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.r16),
        border: Border.all(color: colorScheme.outline),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: _selectedTeamId,
          hint: Row(
            children: [
              Icon(Icons.group, color: colorScheme.primary),
              SizedBox(width: AppSizes.p12),
              const Text('Sélectionner une équipe'),
            ],
          ),
          isExpanded: true,
          items: _teams.map((team) {
            return DropdownMenuItem<int>(
              value: team['id'],
              child: Row(
                children: [
                  Icon(Icons.group_outlined, color: colorScheme.primary, size: 20),
                  SizedBox(width: AppSizes.p12),
                  Text(team['name']),
                ],
              ),
            );
          }).toList(),
          onChanged: (teamId) {
            if (teamId != null) {
              setState(() => _selectedTeamId = teamId);
              _loadDashboard();
            }
          },
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
        // Sélecteur de période
        _buildPeriodSelector(context, colorScheme),
        SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p24)),

        // Chart Attendance/Punctuality
        AttendanceChart(
          punctuality: report.punctuality,
          attendance: report.attendance,
          period: _getPeriodLabel(),
        ),

        SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p24)),

        // Work Chart dynamique
        _buildWorkChartForPeriod(context, report.work, colorScheme),
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

  Widget _buildEmptyState(
    BuildContext context,
    ColorScheme colorScheme,
    String title,
    String subtitle,
  ) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(AppSizes.p24),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.group,
                size: 64,
                color: colorScheme.primary,
              ),
            ),
            SizedBox(height: AppSizes.p24),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: AppSizes.p12),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String msg, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.p24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: colorScheme.error),
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
            Text(
              msg,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: AppSizes.p24),
            ElevatedButton.icon(
              onPressed: _loadDashboard,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
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