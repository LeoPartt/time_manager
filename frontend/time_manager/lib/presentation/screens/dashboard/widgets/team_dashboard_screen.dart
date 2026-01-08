
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/cubits/dashboard/dashboard_cubit.dart';
import 'package:time_manager/presentation/cubits/dashboard/dashboard_state.dart';
import 'package:time_manager/presentation/screens/dashboard/widgets/dashboard_chart.dart';
import 'package:time_manager/presentation/widgets/header.dart';
import 'package:time_manager/presentation/widgets/navbar.dart';

@RoutePage()
class TeamDashboardScreen extends StatefulWidget {
  const TeamDashboardScreen({super.key});

  @override
  State<TeamDashboardScreen> createState() => _TeamDashboardScreenState();
}

class _TeamDashboardScreenState extends State<TeamDashboardScreen> {
  int? selectedTeamId;

 
  final List<Map<String, dynamic>> teams = [
    {'id': 1, 'name': 'Team Marguerite'},
    {'id': 2, 'name': 'Team Alpha'},
    {'id': 3, 'name': 'Team Beta'},
  ];

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      bottomNavigationBar: const NavBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSizes.responsiveWidth(context, AppSizes.p24)),
          child: Column(
            children: [
              Header(label: 'Dashboard Team'),
              SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p24)),
    
              // 🔽 Sélecteur d'équipe
              _buildTeamSelector(colorScheme),
              SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p24)),
    
              // 📊 Affichage du rapport
              BlocBuilder<DashboardCubit, DashboardState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => Center(child: Text('Sélectionnez une équipe')),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    loaded: (report) => Column(
                      children: [
                        _buildKPIRow(context, report, colorScheme),
                        SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p24)),
                        WorkChart(
                          weeklyHours: report.workAverageWeekly,
                          monthlyHours: report.workAverageMonthly,
                        ),
                      ],
                    ),
                    error: (msg) => Center(child: Text('Erreur: $msg', style: TextStyle(color: Colors.red))),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamSelector(ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.p16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.r16),
        border: Border.all(color: colorScheme.outline),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: selectedTeamId,
          hint: const Text('Sélectionner une équipe'),
          isExpanded: true,
          items: teams.map((team) {
            return DropdownMenuItem<int>(
              value: team['id'],
              child: Text(team['name']),
            );
          }).toList(),
          onChanged: (teamId) {
            if (teamId != null) {
              setState(() => selectedTeamId = teamId);
              context.read<DashboardCubit>().loadTeamReport(context, teamId);
            }
          },
        ),
      ),
    );
  }

  Widget _buildKPIRow(BuildContext context, report, ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: _buildKPICard(
            context,
            'Ponctualité',
            '${report.punctualityRate.toStringAsFixed(1)}%',
            Icons.access_time,
            colorScheme.primary,
          ),
        ),
        SizedBox(width: AppSizes.responsiveWidth(context, AppSizes.p16)),
        Expanded(
          child: _buildKPICard(
            context,
            'Assiduité',
            '${report.attendanceRate.toStringAsFixed(1)}%',
            Icons.check_circle,
            colorScheme.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildKPICard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(AppSizes.responsiveWidth(context, AppSizes.p20)),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.r16),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: color),
          SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p8)),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          Text(title, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}