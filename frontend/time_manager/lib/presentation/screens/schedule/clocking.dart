
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:time_manager/core/constants/app_colors.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/core/utils/extensions/context_extensions.dart';
import 'package:time_manager/core/widgets/app_button.dart';
import 'package:time_manager/domain/entities/schedule/daily_work.dart';
import 'package:time_manager/domain/usecases/schedule/get_daily_work.dart';
import 'package:time_manager/initialization/locator.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/cubits/clock/clock_cubit.dart';
import 'package:time_manager/presentation/cubits/clock/clock_state.dart';
import 'package:time_manager/presentation/cubits/user/user_cubit.dart';
import 'package:time_manager/presentation/cubits/user/user_state.dart';
import 'package:time_manager/presentation/widgets/header.dart';
import 'package:time_manager/presentation/widgets/loading_state_widget.dart';
import 'package:time_manager/presentation/widgets/navbar.dart';
import 'dart:async';

@RoutePage()
class ClockingScreen extends StatefulWidget {
  const ClockingScreen({super.key});

  @override
  State<ClockingScreen> createState() => _ClockingScreenState();
}

class _ClockingScreenState extends State<ClockingScreen> {
  Timer? _timer;
  String _currentTime = '';
  String _currentDate = '';
  DailyWork? _todayWork;
  bool _loadingTodayWork = false;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
    
    // Charger les stats du jour
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTodayWork();
    });
  }

  void _updateTime() {
    final now = DateTime.now();
    if (mounted) {
      setState(() {
        _currentTime = DateFormat('HH:mm:ss').format(now);
        _currentDate = DateFormat('EEEE, d MMMM yyyy', 'fr_FR').format(now);
      });
    }
  }

  Future<void> _loadTodayWork() async {
    final userState = context.read<UserCubit>().state;
    
    if (userState is! UserLoaded) return;
    
    setState(() => _loadingTodayWork = true);

    try {
      final getDailyWork = locator<GetDailyWork>();
      final dailyWork = await getDailyWork(
        userId: userState.user.id,
        date: DateTime.now(),
      );

      if (mounted) {
        setState(() {
          _todayWork = dailyWork;
          _loadingTodayWork = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _todayWork = null;
          _loadingTodayWork = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _handleClockAction(BuildContext context, bool isClockedIn) async {
    final tr = AppLocalizations.of(context)!;
    final now = TimeOfDay.now();

    final confirmed = await context.showConfirmDialog(
      title: isClockedIn ? tr.clockout : tr.clockin,
      message: isClockedIn 
          ? tr.clockoutConfirmation 
          : tr.clockinConfirmation,
      confirmText: tr.confirm,
      cancelText: tr.cancel,
    );

    if (!confirmed || !context.mounted) return;

    await context.read<ClockCubit>().toggleClockState(context, now);
    
    // Recharger les stats après le pointage
    await _loadTodayWork();
  }

  Future<void> _handleManualTime(BuildContext context, bool isClockedIn) async {
    final tr = AppLocalizations.of(context)!;
    final now = TimeOfDay.now();

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: now,
      helpText: isClockedIn ? tr.selectClockoutTime : tr.selectClockinTime,
    );

    if (picked == null || !context.mounted) return;

    final currentTime = DateTime.now();
    final selectedDateTime = DateTime(
      currentTime.year,
      currentTime.month,
      currentTime.day,
      picked.hour,
      picked.minute,
    );

    if (selectedDateTime.isAfter(currentTime)) {
      context.showError(tr.cannotClockInFuture);
      return;
    }

    final confirmed = await context.showConfirmDialog(
      title: isClockedIn ? tr.clockout : tr.clockin,
      message: '${isClockedIn ? tr.clockoutAt : tr.clockedInAt} ${picked.format(context)} ?',
      confirmText: tr.confirm,
      cancelText: tr.cancel,
    );

    if (!confirmed || !context.mounted) return;

    await context.read<ClockCubit>().toggleClockState(context, picked);
    
    // Recharger les stats après le pointage
    await _loadTodayWork();
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final isTablet = context.screenWidth >= 600;

    return BlocProvider(
      create: (_) => locator<ClockCubit>()..getStatus(context),
      child: BlocConsumer<ClockCubit, ClockState>(
        listener: (context, state) {
          state.whenOrNull(
            actionClockedIn: (_) {
              context.showSuccess(tr.clockinSuccessful);
              _loadTodayWork();
            },
            actionClockedOut: (_) {
              context.showSuccess(tr.clockoutSuccessful);
              _loadTodayWork();
            },
            error: (msg) {
              context.showError(msg);
              if (msg.contains('déjà') || msg.contains('d\'abord')) {
                context.read<ClockCubit>().getStatus(context);
              }
            },
          );
        },
        builder: (context, state) {
          return Scaffold(
            bottomNavigationBar: const NavBar(),
            body: SafeArea(
              child: state.when(
                initial: () => _buildContent(context, false, null, tr, isTablet),
                loading: () => const LoadingStateWidget(),
                statusClockedIn: (clock) => _buildContent(
                  context,
                  true,
                  clock.arrivalTs,
                  tr,
                  isTablet,
                ),
                actionClockedIn: (clock) => _buildContent(
                  context,
                  true,
                  clock.arrivalTs,
                  tr,
                  isTablet,
                ),
                statusClockedOut: (_) => _buildContent(
                  context,
                  false,
                  null,
                  tr,
                  isTablet,
                ),
                actionClockedOut: (_) => _buildContent(
                  context,
                  false,
                  null,
                  tr,
                  isTablet,
                ),
                error: (msg) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: context.colorScheme.error,
                      ),
                      SizedBox(height: AppSizes.p16),
                      Text(msg),
                      SizedBox(height: AppSizes.p24),
                      AppButton(
                        label: tr.retry,
                        onPressed: () => context.read<ClockCubit>().getStatus(context),
                        icon: Icons.refresh,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    bool isClockedIn,
    DateTime? clockInTime,
    AppLocalizations tr,
    bool isTablet,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<ClockCubit>().getStatus(context);
        await _loadTodayWork();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(AppSizes.responsiveWidth(context, AppSizes.p24)),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 600 : double.infinity,
            ),
            child: Column(
              children: [
                Header(
                  label: tr.clocking,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: _loadTodayWork,
                      tooltip: tr.refresh,
                    ),
                  ],
                ),

                SizedBox(height: AppSizes.p24),

                _buildClockCard(context, isClockedIn, clockInTime, tr, isTablet),

                SizedBox(height: AppSizes.p24),

                _buildActionButtons(context, isClockedIn, tr),

                SizedBox(height: AppSizes.p24),

                _buildTodayStats(context, isClockedIn, clockInTime, tr),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClockCard(
    BuildContext context,
    bool isClockedIn,
    DateTime? clockInTime,
    AppLocalizations tr,
    bool isTablet,
  ) {
    final colorScheme = context.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.p32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isClockedIn
              ? [
                  AppColors.success.withValues(alpha:0.1),
                  AppColors.success.withValues(alpha:0.05),
                ]
              : [
                  colorScheme.primaryContainer.withValues(alpha:0.3),
                  colorScheme.secondaryContainer.withValues(alpha:0.3),
                ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.r24),
        border: Border.all(
          color: isClockedIn
              ? AppColors.success.withValues(alpha:0.3)
              : colorScheme.outline.withValues(alpha:0.2),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.p16,
              vertical: AppSizes.p8,
            ),
            decoration: BoxDecoration(
              color: isClockedIn
                  ? AppColors.success.withValues(alpha:0.2)
                  : colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppSizes.r16),
              border: Border.all(
                color: isClockedIn
                    ? AppColors.success
                    : colorScheme.outline.withValues(alpha:0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isClockedIn ? AppColors.success : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: AppSizes.p8),
                Text(
                  isClockedIn ? tr.clockedIn : tr.clockedOut,
                  style: TextStyle(
                    color: isClockedIn ? AppColors.success : colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: AppSizes.textMd,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: AppSizes.p32),

          Container(
            padding: EdgeInsets.all(AppSizes.p24),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha:0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              Icons.access_time_rounded,
              size: isTablet ? 80 : 64,
              color: isClockedIn ? AppColors.success : colorScheme.primary,
            ),
          ),

          SizedBox(height: AppSizes.p24),

          Text(
            _currentTime,
            style: TextStyle(
              fontSize: isTablet ? 56 : 48,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
              letterSpacing: 2,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),

          SizedBox(height: AppSizes.p8),

          Text(
            _currentDate,
            style: TextStyle(
              fontSize: AppSizes.textMd,
              color: colorScheme.onSurface.withValues(alpha:0.6),
            ),
          ),

          if (isClockedIn && clockInTime != null) ...[
            SizedBox(height: AppSizes.p24),
            Divider(color: colorScheme.outline.withValues(alpha:0.2)),
            SizedBox(height: AppSizes.p16),
            _buildClockInInfo(context, clockInTime, tr),
          ],
        ],
      ),
    );
  }

  Widget _buildClockInInfo(
    BuildContext context,
    DateTime clockInTime,
    AppLocalizations tr,
  ) {
    final colorScheme = context.colorScheme;
    final duration = DateTime.now().difference(clockInTime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.login_rounded,
              size: 20,
              color: AppColors.success,
            ),
            SizedBox(width: AppSizes.p8),
            Text(
              '${tr.clockedInAt} ${DateFormat('HH:mm').format(clockInTime)}',
              style: TextStyle(
                fontSize: AppSizes.textMd,
                color: colorScheme.onSurface.withValues(alpha:0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.p12),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.p16,
            vertical: AppSizes.p8,
          ),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha:0.1),
            borderRadius: BorderRadius.circular(AppSizes.r8),
          ),
          child: Text(
            '${tr.workingFor} ${hours}h ${minutes}min',
            style: TextStyle(
              fontSize: AppSizes.textLg,
              fontWeight: FontWeight.bold,
              color: AppColors.success,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    bool isClockedIn,
    AppLocalizations tr,
  ) {
    final state = context.watch<ClockCubit>().state;
    final isLoading = state is ClockLoading;

    return Column(
      children: [
        AppButton(
          label: isClockedIn ? tr.clockout : tr.clockin,
          onPressed: isLoading
              ? () {}
              : () => _handleClockAction(context, isClockedIn),
          fullSize: true,
          isLoading: isLoading,
          icon: isClockedIn ? Icons.logout_rounded : Icons.login_rounded,
          backgroundColor: isClockedIn ? AppColors.error : AppColors.success,
        ),

        SizedBox(height: AppSizes.p12),

        AppOutlinedButton(
          label: tr.manualTime,
          onPressed: isLoading
              ? () {}
              : () => _handleManualTime(context, isClockedIn),
          fullSize: true,
          icon: Icons.schedule_outlined,
        ),
      ],
    );
  }

  Widget _buildTodayStats(
    BuildContext context,
    bool isClockedIn,
    DateTime? clockInTime,
    AppLocalizations tr,
  ) {
    final colorScheme = context.colorScheme;

    if (_loadingTodayWork) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppSizes.p20),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(AppSizes.r16),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha:0.2),
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Calculer les stats réelles
    final firstClockIn = _getFirstClockIn();
    final totalWorked = _getTotalWorkedHours();
    final expectedTime = _getExpectedTime();
    final variance = expectedTime != null && totalWorked != null
        ? totalWorked - expectedTime
        : null;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.p20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.r16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha:0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.today_outlined,
                color: colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: AppSizes.p8),
              Text(
                tr.todayStats,
                style: TextStyle(
                  fontSize: AppSizes.textLg,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),

          SizedBox(height: AppSizes.p16),

          _buildStatRow(
            context,
            icon: Icons.login_rounded,
            label: tr.firstClockin,
            value: firstClockIn != null
                ? DateFormat('HH:mm').format(firstClockIn)
                : '--:--',
          ),

          Divider(
            height: AppSizes.p16,
            color: colorScheme.outline.withValues(alpha:0.2),
          ),

          _buildStatRow(
            context,
            icon: Icons.timer_outlined,
            label: tr.totalWorked,
            value: totalWorked != null
                ? _formatHours(totalWorked)
                : '0h 0min',
          ),

         
        

          if (variance != null) ...[
            Divider(
              height: AppSizes.p16,
              color: colorScheme.outline.withValues(alpha:0.2),
            ),
            _buildVarianceRow(context, variance, tr),
          ],

          // Status du jour
         
        ],
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final colorScheme = context.colorScheme;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(AppSizes.p8),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha:0.5),
            borderRadius: BorderRadius.circular(AppSizes.r8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: colorScheme.primary,
          ),
        ),
        SizedBox(width: AppSizes.p12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: AppSizes.textSm,
              color: colorScheme.onSurface.withValues(alpha:0.6),
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: AppSizes.textMd,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildVarianceRow(BuildContext context, double varianceHours, AppLocalizations tr) {
    final isPositive = varianceHours >= 0;
    final color = isPositive ? AppColors.success : AppColors.warning;

    return Container(
      padding: EdgeInsets.all(AppSizes.p12),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(AppSizes.r8),
        border: Border.all(
          color: color.withValues(alpha:0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isPositive ? Icons.trending_up : Icons.trending_down,
            color: color,
            size: 20,
          ),
          SizedBox(width: AppSizes.p12),
          Expanded(
            child: Text(
              tr.variance,
              style: TextStyle(
                fontSize: AppSizes.textSm,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            '${isPositive ? '+' : ''}${_formatHours(varianceHours.abs())}',
            style: TextStyle(
              fontSize: AppSizes.textMd,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  
  // Helpers pour extraire les données de DailyWork
  DateTime? _getFirstClockIn() {
    if (_todayWork == null || _todayWork!.workPeriods.isEmpty) {
      return null;
    }
    return _todayWork!.workPeriods.first.clockIn;
  }

  double? _getTotalWorkedHours() {
    if (_todayWork == null) return null;
    return _todayWork!.summary.totalHours;
  }

  double? _getExpectedTime() {
    if (_todayWork == null || _todayWork!.planned == null) {
      return null;
    }
    return _todayWork!.planned!.totalHours;
  }

  String _formatHours(double hours) {
    final h = hours.floor();
    final m = ((hours - h) * 60).round();
    return '${h}h ${m}min';
  }







}