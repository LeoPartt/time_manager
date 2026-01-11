
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/core/utils/extensions/context_extensions.dart';
import 'package:time_manager/initialization/locator.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/cubits/dashboard/dashboard_cubit.dart';
import 'package:time_manager/presentation/cubits/dashboard/dashboard_state.dart';
import 'package:time_manager/presentation/widgets/dashboard/dashboard_content_widget.dart';
import 'package:time_manager/presentation/widgets/dashboard/period_selector_widget.dart';
import 'package:time_manager/presentation/widgets/error_state_widget.dart';
import 'package:time_manager/presentation/widgets/header.dart';
import 'package:time_manager/presentation/widgets/loading_state_widget.dart';
import 'package:time_manager/presentation/widgets/navbar.dart';

@RoutePage()
class GlobalDashboardScreen extends StatelessWidget {
  const GlobalDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<DashboardCubit>(),
      child: const _GlobalDashboardView(),
    );
  }
}

class _GlobalDashboardView extends StatefulWidget {
  const _GlobalDashboardView();

  @override
  State<_GlobalDashboardView> createState() => _GlobalDashboardViewState();
}

class _GlobalDashboardViewState extends State<_GlobalDashboardView> {
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
    final mode = _getModeString(_selectedPeriod);
    context.read<DashboardCubit>().loadGlobalDashboard(
          context,
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
    final colorScheme = context.colorScheme;
    final isTablet = context.screenWidth >= 600;

    return Scaffold(
      bottomNavigationBar: const NavBar(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => _loadDashboard(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(AppSizes.p24),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isTablet ? 1200 : double.infinity,
                ),
                child: Column(
                  children: [
                    Header(
                      label: tr.globalDashboard,
                     
                    ),
                    
                    SizedBox(height: AppSizes.p24),
                    
                    _buildInfoCard(context, tr, colorScheme),
                    
                    SizedBox(height: AppSizes.p24),
                    
                    _buildContent(context, tr, colorScheme),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    AppLocalizations tr,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: EdgeInsets.all(AppSizes.p20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.tertiary,
            colorScheme.tertiary.withValues(alpha:0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.r16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.tertiary.withValues(alpha:0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSizes.p16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha:0.2),
              borderRadius: BorderRadius.circular(AppSizes.r12),
            ),
            child: const Icon(
              Icons.business_rounded,
              size: 32,
              color: Colors.white,
            ),
          ),
          
          SizedBox(width: AppSizes.p16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr.companyOverview,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: AppSizes.p4),
                Text(
                  tr.globalStatisticsAllEmployees,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha:0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    AppLocalizations tr,
    ColorScheme colorScheme,
  ) {
    return BlocConsumer<DashboardCubit, DashboardState>(
      listener: (context, state) {
        state.whenOrNull(
          error: (msg) => context.showError(msg),
        );
      },
      builder: (context, state) {
        return state.when(
          initial: () => LoadingStateWidget(message: tr.initializing),
          loading: () => LoadingStateWidget(message: tr.loadingGlobalDashboard),
          userLoaded: (_) => const SizedBox(),
          teamLoaded: (_) => const SizedBox(),
          globalLoaded: (report) => DashboardContentWidget(
            report: report.dashboard,
            selectedPeriod: _selectedPeriod,
            onPeriodChanged: (period) {
              setState(() => _selectedPeriod = period);
              _loadDashboard();
            },
            colorScheme: colorScheme,
            periodButtonColor: colorScheme.tertiary,
          ),
          error: (msg) => ErrorStateWidget(
            message: msg,
            onRetry: _loadDashboard,
          ),
        );
      },
    );
  }
}