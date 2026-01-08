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
import 'package:time_manager/presentation/screens/dashboard/widgets/team_selector.dart';
import 'package:time_manager/presentation/widgets/header.dart';
import 'package:time_manager/presentation/widgets/navbar.dart';

@RoutePage()
class DashboardScreen extends StatelessWidget {
  final int? userId;

  const DashboardScreen({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // ✅ Crée un NOUVEAU cubit à chaque navigation
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
  @override
  void initState() {
    super.initState();
    
    // ✅ Attendre que le widget soit monté avant d'accéder au contexte
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadDashboard();
      }
    });
  }

  void _loadDashboard() {
    final cubit = context.read<DashboardCubit>();

    // ✅ Si userId fourni, charge directement
    if (widget.userId != null) {
      cubit.loadUserReport(context, widget.userId!);
      return;
    }

    // ✅ Sinon, récupère depuis UserCubit
    final userState = context.read<UserCubit>().state;

    userState.when(
      loaded: (user) {
        cubit.loadUserReport(context, user.id);
      },
      initial: () {
        // UserCubit pas chargé, on attend
      },
      loading: () {
        // UserCubit en loading, on attend
      },
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

                // ✅ Écoute UserCubit ET DashboardCubit
                BlocListener<UserCubit, UserState>(
                  listener: (context, userState) {
                    // ✅ Quand UserCubit devient "loaded", charge le dashboard
                    userState.whenOrNull(
                      loaded: (user) {
                        if (widget.userId == null) {
                          final dashboardState = context.read<DashboardCubit>().state;
                          
                          // ✅ Ne charge QUE si le dashboard n'est pas déjà chargé ou en loading
                          if (dashboardState is Initial) {
                            context.read<DashboardCubit>().loadUserReport(context, user.id);
                          }
                        }
                      },
                    );
                  },
                  child: BlocBuilder<UserCubit, UserState>(
                    builder: (context, userState) {
                      // ✅ Si UserCubit est en loading et DashboardCubit est en initial
                      // → Affiche un loader pour l'utilisateur
                      return BlocBuilder<DashboardCubit, DashboardState>(
                        builder: (context, dashboardState) {
                          // ✅ UserCubit loading + DashboardCubit initial = Attente du profil
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

                          // ✅ Affiche l'état du dashboard
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
    report,
    ColorScheme colorScheme,
  ) {
    return Column(
      children: [
        AttendanceChart(
        punctualityRate: report.punctualityRate,
        attendanceRate: report.attendanceRate,
      ),
      
        SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p24)),
        _buildWorkCharts(context, report, colorScheme),
         SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p24)),
        Row(
                                  children: [
                                    Expanded(
                                      child: AccessibilityUtils.withTooltip(
                                        context,
                                        tooltip: 'Calendar',
                                        child: AppButton(
                                          label: "Calendar",
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
                                        tooltip: "Team",
                                        child: AppButton(
                                          label: "Team",
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

  Widget _buildKPICard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
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
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(title, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildWorkCharts(BuildContext context, report, ColorScheme colorScheme) {
    return Column(
      children: [
        _buildWorkCard(
          context,
          'Hebdomadaire',
          report.workAverageWeekly,
          colorScheme,
        ),
        SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p16)),
        _buildWorkCard(
          context,
          'Mensuel',
          report.workAverageMonthly,
          colorScheme,
        ),
      ],
    );
  }

  Widget _buildWorkCard(
    BuildContext context,
    String period,
    double hours,
    ColorScheme colorScheme,
  ) {
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
            'Travail $period',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p12)),
          Text(
            '${hours.toStringAsFixed(1)} heures',
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
}