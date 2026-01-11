
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/core/utils/extensions/context_extensions.dart';
import 'package:time_manager/core/widgets/app_button.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/cubits/dashboard/dashboard_cubit.dart';
import 'package:time_manager/presentation/cubits/dashboard/dashboard_state.dart';
import 'package:time_manager/presentation/cubits/user/user_cubit.dart';
import 'package:time_manager/presentation/cubits/user/user_state.dart';
import 'package:time_manager/presentation/routes/app_router.dart';
import 'package:time_manager/presentation/widgets/dashboard/dashboard_content_widget.dart';
import 'package:time_manager/presentation/widgets/dashboard/period_selector_widget.dart';
import 'package:time_manager/presentation/widgets/error_state_widget.dart';
import 'package:time_manager/presentation/widgets/header.dart';
import 'package:time_manager/presentation/widgets/loading_state_widget.dart';
import 'package:time_manager/presentation/widgets/navbar.dart';

@RoutePage()
class DashboardScreen extends StatelessWidget {
  final int? userId;
  final bool showbutton;

  const DashboardScreen({super.key, this.userId, this.showbutton = true});

  @override
  Widget build(BuildContext context) {
    return _DashboardView(userId: userId, showbutton: showbutton,);
  }
}

class _DashboardView extends StatefulWidget {
  final int? userId;
    final bool showbutton;
  

  const _DashboardView({this.userId, this.showbutton = true});

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
    userState.whenOrNull(
      loaded: (user) {
        cubit.loadUserDashboard(
          context,
          userId: user.id,
          mode: mode,
        );
      },
      updated: (user) {
        cubit.loadUserDashboard(
          context,
          userId: user.id,
          mode: mode,
        );
      },
      error: (msg) => context.showError(msg),
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
            padding: EdgeInsets.all(AppSizes.responsiveWidth(context, AppSizes.p24)),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isTablet ? 1200 : double.infinity,
                ),
                child: Column(
                  children: [
                    Header(
                      label: tr.dashboard,
                      leading: widget.userId != null
                          ? IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () => context.router.pop(),
                            )
                          : null,
                    ),
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
    return BlocListener<UserCubit, UserState>(
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
            final tr = AppLocalizations.of(context)!;
          return BlocBuilder<DashboardCubit, DashboardState>(
            builder: (context, dashboardState) {
              if (userState is UserLoading && dashboardState is Initial) {
                return  LoadingStateWidget(
                  message:  tr.loadingProfile,
                );
              }

              return dashboardState.when(
                initial: () =>  LoadingStateWidget(
                  message:  tr.initializing,
                ),
                loading: () =>  LoadingStateWidget(
                  message:  tr.loadingDashboard,
                ),
                userLoaded: (report) => DashboardContentWidget(
                  report: report.dashboard,
                  selectedPeriod: _selectedPeriod,
                  onPeriodChanged: (period) {
                    setState(() => _selectedPeriod = period);
                    _loadDashboard();
                  },
                  colorScheme: colorScheme,
                  additionalActions: widget.showbutton
                      ? _buildNavigationButtons(context)
                      : null,
                ),
                teamLoaded: (_) => const SizedBox(),
                globalLoaded: (_) => const SizedBox(),
                error: (msg) => ErrorStateWidget(
                  message: msg,
                  onRetry: _loadDashboard,
                  showDetailedError: true,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
                final tr = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: AppButton(
            label: tr.planning,
            fullSize: true,
            onPressed: () => context.pushRoute(PlanningCalendarRoute()),
          ),
        ),
        
      ],
    );
  }
}