import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/core/utils/accessibility_utils.dart';
import 'package:time_manager/core/utils/extensions/context_extensions.dart';
import 'package:time_manager/core/widgets/app_button.dart';
import 'package:time_manager/initialization/locator.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/cubits/clock/clock_cubit.dart';
import 'package:time_manager/presentation/cubits/clock/clock_state.dart';
import 'package:time_manager/presentation/widgets/header.dart';
import 'package:time_manager/presentation/widgets/navbar.dart';

@RoutePage()
class ClockingScreen extends StatefulWidget {
  const ClockingScreen({super.key});

  @override
  State<ClockingScreen> createState() => _ClockingScreenState();
}

class _ClockingScreenState extends State<ClockingScreen> {
  final _timeController = TextEditingController();

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final size = MediaQuery.sizeOf(context);
    final isTablet = size.width >= 600;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocProvider(
      create: (_) => locator<ClockCubit>()..getStatus(context),
      child: BlocConsumer<ClockCubit, ClockState>(
        listener: (context, state) {
          state.whenOrNull(
            // ✅ Notifications UNIQUEMENT pour les états d'ACTION
            actionClockedIn: (_) => context.showSnack(
              "✅ ${tr.clockin} ${tr.successful}!",
            ),
            actionClockedOut: (_) => context.showSnack(
              "✅ ${tr.clockout} ${tr.successful}!",
            ),
            
            // ⚠️ Erreurs
            error: (msg) {
              context.showSnack("⚠️ $msg", isError: true);
              
              if (msg.contains('déjà clocké')) {
                context.read<ClockCubit>().getStatus(context);
              }
            },
          );
        },
        builder: (context, state) {
          final isLoading = state is ClockLoading;
          
          // ✅ L'utilisateur est clocké IN si l'état est statusClockedIn OU actionClockedIn
          final isClockedIn = state is StatusClockedIn || state is ActionClockedIn;

          return Scaffold(
            bottomNavigationBar: const NavBar(),
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  vertical: AppSizes.responsiveHeight(context, AppSizes.p24),
                  horizontal: AppSizes.responsiveWidth(context, AppSizes.p24),
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isTablet ? 600 : double.infinity,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AccessibilityUtils.withLabel(
                          label: isClockedIn ? tr.clockout : tr.clockin,
                          child: Header(
                            label: isClockedIn ? tr.clockout : tr.clockin,
                          ),
                        ),
                        SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p24)),

                        Semantics(
                          label: tr.clockin,
                          container: true,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(
                              AppSizes.responsiveWidth(context, AppSizes.p20),
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.secondary,
                              borderRadius: BorderRadius.circular(AppSizes.r24),
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.shadow.withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                AccessibilityUtils.withTooltip(
                                  context,
                                  tooltip: tr.clockin,
                                  child: Icon(
                                    Icons.access_time,
                                    size: AppSizes.responsiveWidth(
                                      context,
                                      isTablet ? 100 : 80,
                                    ),
                                    color: colorScheme.onSurface,
                                    semanticLabel: "Clock icon",
                                  ),
                                ),
                                SizedBox(
                                  height: AppSizes.responsiveHeight(
                                    context,
                                    AppSizes.p24,
                                  ),
                                ),

                                Semantics(
                                  label: isClockedIn ? tr.departure : tr.arrival,
                                  hint: tr.validate,
                                  textField: true,
                                  child: TextField(
                                    controller: _timeController,
                                    readOnly: true,
                                    onTap: () => _selectTime(context),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: AppSizes.responsiveText(
                                        context,
                                        AppSizes.textLg,
                                      ),
                                    ),
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.schedule),
                                      hintText: isClockedIn
                                          ? tr.departure
                                          : tr.arrival,
                                      hintStyle: TextStyle(
                                        fontSize: AppSizes.responsiveText(
                                          context,
                                          AppSizes.textMd,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppSizes.r16,
                                        ),
                                        borderSide: BorderSide(
                                          color: colorScheme.secondary,
                                          width: 2,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: colorScheme.primary,
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: AppSizes.responsiveHeight(
                                    context,
                                    AppSizes.p24,
                                  ),
                                ),

                                AccessibilityUtils.withLabel(
                                  label: isClockedIn ? tr.clockout : tr.clockin,
                                  child: AppButton(
                                    fullSize: true,
                                    isLoading: isLoading,
                                    label: isClockedIn ? tr.clockout : tr.clockin,
                                    onPressed: () async {
                                      final picked = _timeController.text;
                                      if (picked.isNotEmpty) {
                                        final parsedTime = TimeOfDay.fromDateTime(
                                          DateFormat.jm().parse(picked),
                                        );

                                        await context
                                            .read<ClockCubit>()
                                            .toggleClockState(context, parsedTime);

                                        _timeController.clear();
                                      } else {
                                        context.showSnack(
                                          "⚠️ ${tr.validate}",
                                          isError: true,
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}