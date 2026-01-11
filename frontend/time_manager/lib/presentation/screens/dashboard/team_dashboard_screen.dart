import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/core/utils/extensions/context_extensions.dart';
import 'package:time_manager/initialization/locator.dart';
import 'package:time_manager/presentation/cubits/dashboard/dashboard_cubit.dart';
import 'package:time_manager/presentation/cubits/dashboard/dashboard_state.dart';
import 'package:time_manager/presentation/cubits/team/team_cubit.dart';
import 'package:time_manager/presentation/cubits/team/team_state.dart';
import 'package:time_manager/presentation/widgets/dashboard/dashboard_content_widget.dart';
import 'package:time_manager/presentation/widgets/dashboard/period_selector_widget.dart';
import 'package:time_manager/presentation/widgets/error_state_widget.dart';
import 'package:time_manager/presentation/widgets/header.dart';
import 'package:time_manager/presentation/widgets/loading_state_widget.dart';
import 'package:time_manager/presentation/widgets/navbar.dart';

@RoutePage()
class TeamDashboardScreen extends StatelessWidget {
  final int? teamId;

  const TeamDashboardScreen({super.key, this.teamId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => locator<DashboardCubit>()),
        BlocProvider(create: (context) => locator<TeamCubit>()),
      ],
      child: _TeamDashboardView(teamId: teamId),
    );
  }
}

class _TeamDashboardView extends StatefulWidget {
  final int? teamId;

  const _TeamDashboardView({this.teamId});

  @override
  State<_TeamDashboardView> createState() => _TeamDashboardViewState();
}

class _TeamDashboardViewState extends State<_TeamDashboardView> {
  ReportPeriod _selectedPeriod = ReportPeriod.week;
  int? _selectedTeamId;

  @override
  void initState() {
    super.initState();
    _selectedTeamId = widget.teamId;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<TeamCubit>().getTeams();
        if (_selectedTeamId != null) {
          _loadDashboard();
        }
      }
    });
  }

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
    final colorScheme = context.colorScheme;

    return Scaffold(
      bottomNavigationBar: const NavBar(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => _loadDashboard(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(AppSizes.responsiveWidth(context, AppSizes.p24)),
            child: Column(
              children: [
                Header(label: 'Dashboard Équipe'),
                SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p24)),
                _buildTeamSelector(context, colorScheme),
                SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p24)),
                _buildContent(context, colorScheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamSelector(BuildContext context, ColorScheme colorScheme) {
    return BlocBuilder<TeamCubit, TeamState>(
      builder: (context, state) {
        return state.when(
          initial: () => const SizedBox(),
          loading: () => const LinearProgressIndicator(),
          loaded: (_) =>  LoadingStateWidget(),
          loadedTeams: (teams) {
            if (teams.isEmpty) {
              return Container(
                padding: EdgeInsets.all(AppSizes.p16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(AppSizes.r12),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange),
                    SizedBox(width: AppSizes.p12),
                    Expanded(
                      child: Text(
                        'Aucune équipe disponible',
                        style: TextStyle(color: Colors.orange.shade900),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Container(
              padding: EdgeInsets.all(AppSizes.p12),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(AppSizes.r12),
                border: Border.all(color: colorScheme.outline.withValues(alpha:0.2)),
              ),
              child: DropdownButtonFormField<int>(
                initialValue: _selectedTeamId,
                decoration: InputDecoration(
                  labelText: 'Sélectionner une équipe',
                  prefixIcon: Icon(Icons.groups, color: colorScheme.secondary),
                  border: InputBorder.none,
                ),
                items: teams.map((team) {
                  return DropdownMenuItem(
                    value: team.id,
                    child: Text(team.name),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedTeamId = value);
                    _loadDashboard();
                  }
                },
              ),
            );
          },
          error: (msg) => Container(
            padding: EdgeInsets.all(AppSizes.p16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(AppSizes.r12),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red),
                SizedBox(width: AppSizes.p12),
                Expanded(
                  child: Text(
                    msg,
                    style: TextStyle(color: Colors.red.shade900),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, ColorScheme colorScheme) {
    if (_selectedTeamId == null) {
      return Container(
        padding: EdgeInsets.all(48),
        child: Column(
          children: [
            Icon(
              Icons.groups_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            SizedBox(height: AppSizes.p16),
            Text(
              'Sélectionnez une équipe',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: AppSizes.p8),
            Text(
              'Choisissez une équipe pour voir ses statistiques',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return BlocConsumer<DashboardCubit, DashboardState>(
      listener: (context, state) {
        state.whenOrNull(
          error: (msg) => context.showError(msg),
        );
      },
      builder: (context, state) {
        return state.when(
          initial: () => const LoadingStateWidget(),
          loading: () => const LoadingStateWidget(
            message: 'Chargement du dashboard de l\'équipe...',
          ),
          userLoaded: (_) => const SizedBox(),
          teamLoaded: (report) => DashboardContentWidget(
            report: report.dashboard,
            selectedPeriod: _selectedPeriod,
            onPeriodChanged: (period) {
              setState(() => _selectedPeriod = period);
              _loadDashboard();
            },
            colorScheme: colorScheme,
            periodButtonColor: colorScheme.secondary,
          ),
          globalLoaded: (_) => const SizedBox(),
          error: (msg) => ErrorStateWidget(
            message: msg,
            onRetry: _loadDashboard,
          ),
        );
      },
    );
  }
}