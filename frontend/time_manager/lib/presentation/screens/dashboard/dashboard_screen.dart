import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/initialization/locator.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/cubits/dashboard/dashboard_cubit.dart';
import 'package:time_manager/presentation/cubits/dashboard/dashboard_state.dart';
import 'package:time_manager/presentation/cubits/user/user_cubit.dart';
import 'package:time_manager/presentation/cubits/user/user_state.dart';
import 'package:time_manager/presentation/widgets/header.dart';
import 'package:time_manager/presentation/widgets/navbar.dart';

@RoutePage()
class DashboardScreen extends StatefulWidget {
  final int? userId; // null = dashboard personnel, sinon dashboard équipe/utilisateur
  
  const DashboardScreen({super.key, this.userId});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Charge les données au démarrage
    _loadDashboard();
  }
   void _loadDashboard() {
    // ✅ Si userId est fourni explicitement → utilise-le
    if (widget.userId != null) {
      context.read<DashboardCubit>().loadUserReport(context, widget.userId!);
      return;
    }

    // ✅ Sinon → récupère l'utilisateur connecté depuis UserCubit (déjà global)
    final userState = context.read<UserCubit>().state;
    
    userState.whenOrNull(
      loaded: (user) {
        // Utilisateur connecté disponible
        context.read<DashboardCubit>().loadUserReport(context, user.id);
      },
      // Si pas encore chargé, restoreSession() a déjà été appelé dans Application
      // donc on attend un instant puis on réessaye
      initial: () {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) _loadDashboard();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocProvider(
      create: (_) => locator<DashboardCubit>(),
      child: Scaffold(
        bottomNavigationBar: const NavBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppSizes.responsiveWidth(context, AppSizes.p24)),
            child: Column(
              children: [
                Header(label: tr.dashboard ),
                SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p24)),
                
                BlocBuilder<DashboardCubit, DashboardState>(
                  builder: (context, state) {
                    return state.when(
                      initial: () => const Center(child: Text('Chargement...')),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      loaded: (report) => _buildDashboardContent(context, report, colorScheme),
                      error: (msg) => Center(child: Text('Erreur: $msg', style: TextStyle(color: Colors.red))),
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

  Widget _buildDashboardContent(BuildContext context, report, ColorScheme colorScheme) {
    return Column(
      children: [
        // 📊 KPI Cards
        _buildKPIRow(context, report, colorScheme),
        SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p24)),
        
        // 📈 Graphiques hebdomadaires/mensuels
        _buildWorkCharts(context, report, colorScheme),
      ],
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

  Widget _buildWorkCharts(BuildContext context, report, ColorScheme colorScheme) {
    return Column(
      children: [
        _buildWorkCard(context, 'Hebdomadaire', report.workAverageWeekly, colorScheme),
        SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p16)),
        _buildWorkCard(context, 'Mensuel', report.workAverageMonthly, colorScheme),
      ],
    );
  }

  Widget _buildWorkCard(BuildContext context, String period, double hours, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.responsiveWidth(context, AppSizes.p20)),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.r16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Travail $period', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p12)),
          Text('${hours.toStringAsFixed(1)} heures', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: colorScheme.primary)),
        ],
      ),
    );
  }
}