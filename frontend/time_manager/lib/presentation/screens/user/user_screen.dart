

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/core/constants/app_colors.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/core/utils/extensions/context_extensions.dart';
import 'package:time_manager/core/widgets/app_avatars.dart';
import 'package:time_manager/core/widgets/app_button.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/cubits/account/auth_cubit.dart';
import 'package:time_manager/presentation/cubits/user/user_cubit.dart';
import 'package:time_manager/presentation/cubits/user/user_state.dart';
import 'package:time_manager/presentation/routes/app_router.dart';
import 'package:time_manager/presentation/widgets/header.dart';
import 'package:time_manager/presentation/widgets/loading_state_widget.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<UserCubit>().state;
      if (state is! UserLoaded) {
        context.read<UserCubit>().loadProfile();
      }
    });
  }

  Future<void> _handleLogout(BuildContext context) async {
    final tr = AppLocalizations.of(context)!;
    
    final confirmed = await context.showConfirmDialog(
      title: tr.logout,
      message: tr.logoutConfirmation,
      confirmText: tr.logout,
      cancelText: tr.cancel,
    );

    if (confirmed && context.mounted) {
      await context.read<AuthCubit>().logout();
      context.showSuccess(tr.logoutSuccessful);
      context.router.replaceAll([const LoginRoute()]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final isTablet = context.screenWidth >= 600;

    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        state.whenOrNull(
          error: (msg) => context.showError(msg),
        );
      },
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: const NavBar(),
          body: SafeArea(
            child: state.when(
              initial: () => const LoadingStateWidget(),
              loading: () => const LoadingStateWidget(),
              loaded: (user) => _buildContent(context, user, tr, isTablet),
              updated: (user) => _buildContent(context, user, tr, isTablet),
              listLoaded: (_) => const SizedBox.shrink(),
              deleted: () => const SizedBox.shrink(),
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
                      onPressed: () => context.read<UserCubit>().loadProfile(),
                      icon: Icons.refresh,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    dynamic user,
    AppLocalizations tr,
    bool isTablet,
  ) {
    final colorScheme = context.colorScheme;

    return SingleChildScrollView(
      padding: EdgeInsets.all(
        AppSizes.responsiveWidth(context, AppSizes.p24),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isTablet ? 600 : double.infinity,
          ),
          child: Column(
            children: [
              // Header
              Header(
                label: tr.myProfile,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () => context.pushRoute(
                      UserEditRoute(userId: user.id),
                    ),
                    tooltip: tr.editProfile,
                  ),
                ],
              ),
              
              SizedBox(height: AppSizes.p24),
              
              // Profile Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSizes.p24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primaryContainer.withValues(alpha:0.3),
                      colorScheme.secondaryContainer.withValues(alpha:0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppSizes.r24),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha:0.2),
                  ),
                ),
                child: Column(
                  children: [
                    // Avatar avec badge de rôle
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        AppAvatar(
                          radius: isTablet ? 60 : 50,
                          fallbackIcon: Icons.person_outline_rounded,
                          showBorder: true,
                        ),
                        if (user.isAdministrator || user.isManager)
                          Positioned(
                            bottom: -5,
                            right: -5,
                            child: Container(
                              padding: EdgeInsets.all(AppSizes.p8),
                              decoration: BoxDecoration(
                                color: user.isAdministrator
                                    ? AppColors.error
                                    : AppColors.warning,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: colorScheme.surface,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                user.isAdministrator
                                    ? Icons.admin_panel_settings
                                    : Icons.supervisor_account,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                    
                    SizedBox(height: AppSizes.p16),
                    
                    // Nom complet
                    Text(
                      '${user.firstName} ${user.lastName}',
                      style: context.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: isTablet ? AppSizes.textXxl : AppSizes.textXl,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    SizedBox(height: AppSizes.p4),
                    
                    // Username
                    Text(
                      '@${user.username}',
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha:0.6),
                      ),
                    ),
                    
                    if (user.isAdministrator || user.isManager) ...[
                      SizedBox(height: AppSizes.p12),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.p16,
                          vertical: AppSizes.p8,
                        ),
                        decoration: BoxDecoration(
                          color: user.isAdministrator
                              ? AppColors.error.withValues(alpha:0.1)
                              : AppColors.warning.withValues(alpha:0.1),
                          borderRadius: BorderRadius.circular(AppSizes.r16),
                          border: Border.all(
                            color: user.isAdministrator
                                ? AppColors.error.withValues(alpha:0.3)
                                : AppColors.warning.withValues(alpha:0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              user.isAdministrator
                                  ? Icons.verified_user
                                  : Icons.badge,
                              size: 16,
                              color: user.isAdministrator
                                  ? AppColors.error
                                  : AppColors.warning,
                            ),
                            SizedBox(width: AppSizes.p8),
                            Text(
                              user.isAdministrator
                                  ? tr.administrator
                                  : tr.manager,
                              style: TextStyle(
                                color: user.isAdministrator
                                    ? AppColors.error
                                    : AppColors.warning,
                                fontWeight: FontWeight.w600,
                                fontSize: AppSizes.textSm,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    
                    SizedBox(height: AppSizes.p32),
                    
                    // Informations complètes
                    _buildInfoRow(
                      context,
                      icon: Icons.person_outline,
                      label: tr.username,
                      value: user.username,
                    ),
                    
                    SizedBox(height: AppSizes.p12),
                    
                    _buildInfoRow(
                      context,
                      icon: Icons.badge_outlined,
                      label: tr.firstName,
                      value: user.firstName,
                    ),
                    
                    SizedBox(height: AppSizes.p12),
                    
                    _buildInfoRow(
                      context,
                      icon: Icons.badge_outlined,
                      label: tr.lastName,
                      value: user.lastName,
                    ),
                    
                    SizedBox(height: AppSizes.p12),
                    
                    _buildInfoRow(
                      context,
                      icon: Icons.email_outlined,
                      label: tr.emailLabel,
                      value: user.email,
                    ),
                    
                    SizedBox(height: AppSizes.p12),
                    
                    _buildInfoRow(
                      context,
                      icon: Icons.phone_outlined,
                      label: tr.phoneNumber,
                      value: user.phoneNumber ?? tr.notProvided,
                    ),
                    
                    SizedBox(height: AppSizes.p32),
                    
                    // Actions
                    Column(
                      children: [
                        AppButton(
                          label: tr.editProfile,
                          onPressed: () => context.pushRoute(
                            UserEditRoute(userId: user.id),
                          ),
                          fullSize: true,
                          icon: Icons.edit_outlined,
                        ),
                        
                        SizedBox(height: AppSizes.p12),
                        
                        AppOutlinedButton(
                          label: tr.logout,
                          onPressed: () => _handleLogout(context),
                          fullSize: true,
                          icon: Icons.logout_rounded,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final colorScheme = context.colorScheme;
    
    return Container(
      padding: EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.r12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha:0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSizes.p8),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha:0.5),
              borderRadius: BorderRadius.circular(AppSizes.r8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: colorScheme.primary,
            ),
          ),
          SizedBox(width: AppSizes.p16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: AppSizes.textSm,
                    color: colorScheme.onSurface.withValues(alpha:0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: AppSizes.textMd,
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}