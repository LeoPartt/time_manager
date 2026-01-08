import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/core/utils/accessibility_utils.dart';
import 'package:time_manager/core/utils/extensions/context_extensions.dart';
import 'package:time_manager/core/widgets/app_avatars.dart';
import 'package:time_manager/core/widgets/app_button.dart';
import 'package:time_manager/core/widgets/app_label_container.dart';
import 'package:time_manager/core/widgets/app_loader.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/cubits/user/user_cubit.dart';
import 'package:time_manager/presentation/cubits/user/user_state.dart';
import 'package:time_manager/presentation/routes/app_router.dart';
import 'package:time_manager/presentation/widgets/header.dart';
import 'package:time_manager/presentation/widgets/navbar.dart';

@RoutePage()
class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final size = MediaQuery.sizeOf(context);
    final isTablet = size.width >= 600;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        state.whenOrNull(
          deleted: () {
            context.showSnack("✅ ${tr.delete} ${tr.successful}");
            context.router.replaceAll([const LoginRoute()]);
          },
          error: (msg) => context.showSnack(msg, isError: true),
        );
      },
      builder: (context, state) {
        if (state is UserLoading) {
          return const Center(child: AppLoader());
        }

        if (state is UserLoaded) {
          final user = state.user;

          return Scaffold(
            bottomNavigationBar: const NavBar(),
            resizeToAvoidBottomInset: true,

            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.responsiveWidth(context, AppSizes.p24),
                  vertical: AppSizes.responsiveHeight(context, AppSizes.p24),
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isTablet ? 600 : double.infinity,
                    ),
                    child: Column(
                      children: [
                        // ────────────── HEADER ──────────────
                        AccessibilityUtils.withLabel(
                          label: tr.me,
                          child: Header(label: tr.me.toUpperCase()),
                        ),
                        SizedBox(
                          height: AppSizes.responsiveHeight(
                            context,
                            AppSizes.p24,
                          ),
                        ),

                        // ────────────── PROFILE CARD ──────────────
                        Semantics(
                          label: '${tr.me} profile information',
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
                                  color: colorScheme.shadow.withValues(
                                    alpha: 0.2,
                                  ),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Avatar
                                AccessibilityUtils.withTooltip(
                                  context,
                                  tooltip: tr.me,
                                  child: AppAvatar(
                                    radius: isTablet ? 60 : 40,
                                    fallbackIcon: Icons.person_outline_rounded,
                                  ),
                                ),

                                SizedBox(
                                  height: AppSizes.responsiveHeight(
                                    context,
                                    AppSizes.p24,
                                  ),
                                ),

                                // User Information
                                AccessibilityUtils.withLabel(
                                  label:
                                      '${tr.firstNameLabel}: ${user.firstName}',
                                  child: AppLabelContainer(
                                    label:
                                        "${tr.firstNameLabel}: ${user.firstName}",
                                    fullSize: true,
                                  ),
                                ),
                                const SizedBox(height: AppSizes.p12),

                                AccessibilityUtils.withLabel(
                                  label:
                                      '${tr.lastNameLabel}: ${user.lastName}',
                                  child: AppLabelContainer(
                                    label:
                                        "${tr.lastNameLabel}: ${user.lastName}",
                                    fullSize: true,
                                  ),
                                ),
                                const SizedBox(height: AppSizes.p12),

                                AccessibilityUtils.withLabel(
                                  label: '${tr.emailLabel}: ${user.email}',
                                  child: AppLabelContainer(
                                    label: "${tr.emailLabel}: ${user.email}",
                                    fullSize: true,
                                  ),
                                ),

                                const SizedBox(height: AppSizes.p12),

                                AccessibilityUtils.withLabel(
                                  label:
                                      '${tr.phoneNumberLabel}: ${user.phoneNumber ?? '-'}',
                                  child: AppLabelContainer(
                                    label:
                                        "${tr.phoneNumberLabel}: ${user.phoneNumber ?? '-'}",
                                    fullSize: true,
                                  ),
                                ),

                                SizedBox(
                                  height: AppSizes.responsiveHeight(
                                    context,
                                    AppSizes.p24,
                                  ),
                                ),

                                // ────────────── ACTION BUTTONS ──────────────
                                Row(
                                  children: [
                                    Expanded(
                                      child: AccessibilityUtils.withTooltip(
                                        context,
                                        tooltip: tr.modify,
                                        child: AppButton(
                                          label: tr.modify,
                                          fullSize: true,
                                          onPressed: () => context.pushRoute(
                                            UserEditRoute(userId: user.id),
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
                                        tooltip: tr.delete,
                                        child: AppButton(
                                          label: tr.delete,
                                          fullSize: true,
                                          isLoading: state is UserLoading,
                                          onPressed: () => context
                                              .read<UserCubit>()
                                              .removeAccount(context, user.id),
                                        ),
                                      ),
                                    ),
                                  ],
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
        }

        return const SizedBox.shrink();
      },
    );
  }
}
