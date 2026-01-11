// 📁 lib/presentation/widgets/navbar.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/core/constants/app_colors.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/presentation/cubits/account/auth_cubit.dart';
import 'package:time_manager/presentation/cubits/account/auth_state.dart';
import 'package:time_manager/presentation/cubits/navigation/navbar_cubit.dart';
import 'package:time_manager/presentation/cubits/navigation/navbar_state.dart';
import 'package:time_manager/presentation/cubits/user/user_cubit.dart';
import 'package:time_manager/presentation/cubits/user/user_state.dart';
import 'package:time_manager/presentation/routes/app_router.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      
      
      final authState = context.read<AuthCubit>().state;
      authState.whenOrNull(
        authenticated: (user, isNewLogin) {
          
          // ✅ Charger le profil pour TOUS les utilisateurs sauf l'admin pur
          final isPureAdmin = user.isAdministrator && user.username.toLowerCase() == 'admin';
          
          if (!isPureAdmin) {
            final userState = context.read<UserCubit>().state;
            
            userState.whenOrNull(
              initial: () {
                context.read<UserCubit>().loadProfile();
              },
              error: (msg) {
                context.read<UserCubit>().loadProfile();
              },
            );
          } else {
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);


    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        
        return authState.when(
          initial: () {
            return const SizedBox.shrink();
          },
          loading: () {
            return _buildLoadingNavBar(context, colorScheme, size);
          },
          authenticated: (user, isNewLogin) {
            
            // ✅ Admin pur → Afficher directement la NavBar admin
            final isPureAdmin = user.isAdministrator && user.username.toLowerCase() == 'admin';
            
            if (isPureAdmin) {
              return _buildNavBar(
                context,
                _getAdminNavItems(),
                colorScheme,
                size,
              );
            }

            // ✅ Autres utilisateurs → Attendre UserCubit
            return BlocBuilder<UserCubit, UserState>(
              builder: (context, userState) {
                
                return userState.when(
                  initial: () {
                    return _buildLoadingNavBar(context, colorScheme, size);
                  },
                  loading: () {
                    return _buildLoadingNavBar(context, colorScheme, size);
                  },
                  loaded: (fullUser) {
                    
                    final navItems = _getUserNavItems(
                      fullUser.isManager,
                      fullUser.isAdministrator,
                    );
                    
                    return _buildNavBar(
                      context,
                      navItems,
                      colorScheme,
                      size,
                    );
                  },
                  listLoaded: (_) {
                    return _buildLoadingNavBar(context, colorScheme, size);
                  },
                  updated: (fullUser) {
                    
                    final navItems = _getUserNavItems(
                      fullUser.isManager,
                      fullUser.isAdministrator,
                    );
                    
                    return _buildNavBar(
                      context,
                      navItems,
                      colorScheme,
                      size,
                    );
                  },
                  deleted: () {
                    return const SizedBox.shrink();
                  },
                  error: (msg) {
                    // ✅ En cas d'erreur, utiliser les infos de AuthCubit
                    return _buildNavBar(
                      context,
                      _getUserNavItems(user.isManager, user.isAdministrator),
                      colorScheme,
                      size,
                    );
                  },
                );
              },
            );
          },
          unauthenticated: () {
            return const SizedBox.shrink();
          },
          error: (msg) {
            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  Widget _buildLoadingNavBar(
    BuildContext context,
    ColorScheme colorScheme,
    Size size,
  ) {
    return Container(
      margin: EdgeInsets.all(
        AppSizes.responsiveHeight(context, size.height * 0.02),
      ),
      padding: EdgeInsets.symmetric(
        vertical: AppSizes.responsiveHeight(context, size.height * 0.01),
      ),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.25),
            offset: const Offset(0, 4),
            blurRadius: AppSizes.r12,
          ),
        ],
      ),
      child: const Center(
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildNavBar(
    BuildContext context,
    List<NavItem> navItems,
    ColorScheme colorScheme,
    Size size,
  ) {
    
    return Container(
      margin: EdgeInsets.all(
        AppSizes.responsiveHeight(context, size.height * 0.02),
      ),
      padding: EdgeInsets.symmetric(
        vertical: AppSizes.responsiveHeight(context, size.height * 0.01),
      ),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.25),
            offset: const Offset(0, 4),
            blurRadius: AppSizes.r12,
          ),
        ],
      ),
      child: BlocBuilder<NavCubit, NavState>(
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(navItems.length, (index) {
              final item = navItems[index];
              final isSelected = index == state.index;

              return IconButton(
                onPressed: () {
                  context.pushRoute(item.route);
                  context.read<NavCubit>().changeTab(index);
                },
                icon: Icon(
                  item.icon,
                  size: AppSizes.responsiveHeight(context, AppSizes.iconLarge),
                  color: isSelected
                      ? colorScheme.primary
                      : Theme.of(context).scaffoldBackgroundColor,
                ),
              );
            }),
          );
        },
      ),
    );
  }

  List<NavItem> _getAdminNavItems() {
    return [
      NavItem(Icons.business_outlined, const GlobalDashboardRoute()),
      NavItem(Icons.people_outline, const ManagementRoute()),
      NavItem(Icons.calendar_today,  PlanningManagementRoute()),
      NavItem(Icons.dashboard_outlined,  UsersTeamsManagementRoute()),
      NavItem(Icons.settings, const SettingsRoute()),
    ];
  }

  List<NavItem> _getUserNavItems(bool isManager, bool isAdministrator) {
    
    if (isAdministrator) {
      return [
        NavItem(Icons.people_outline, const ManagementRoute()),
        NavItem(Icons.calendar_today, PlanningManagementRoute()),
        NavItem(Icons.dashboard_outlined,  UsersTeamsManagementRoute()),
        NavItem(Icons.settings, const SettingsRoute()),
      ];
    } else if (isManager) {
      return [
        NavItem(Icons.bar_chart_rounded,  DashboardRoute()),
        NavItem(Icons.work_history_rounded, const ClockingRoute()),
        NavItem(Icons.dashboard_outlined,  UsersTeamsManagementRoute()),
        NavItem(Icons.person_rounded, const UserRoute()),
        NavItem(Icons.settings, const SettingsRoute()),
      ];
    } else {
      return [
        NavItem(Icons.bar_chart_rounded,  DashboardRoute()),
        NavItem(Icons.work_history_rounded, const ClockingRoute()),
        NavItem(Icons.person_rounded, const UserRoute()),
        NavItem(Icons.settings, const SettingsRoute()),
      ];
    }
  }
}

class NavItem {
  final IconData icon;
  final PageRouteInfo route;

  NavItem(this.icon, this.route);
}
