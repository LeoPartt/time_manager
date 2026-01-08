import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/core/constants/app_colors.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/presentation/cubits/navigation/navbar_cubit.dart';
import 'package:time_manager/presentation/cubits/navigation/navbar_state.dart';
import 'package:time_manager/presentation/routes/app_router.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
   final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

    final size = MediaQuery.sizeOf(context);
    final icons = const [
      Icons.bar_chart_rounded,
      Icons.work_history_rounded,
      Icons.group_rounded,
      Icons.person_rounded,
      Icons.settings,
    ];
    final routes = [
      const HomeRoute(),
      const ClockingRoute(),
      const ManagementRoute(),
      const UserRoute(),
      const SettingsRoute(),
    ];

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
            children: List.generate(icons.length, (index) {
              final isSelected = index == state.index;
              return IconButton(
                onPressed: () => {
                  context.pushRoute(routes[index]),
                  context.read<NavCubit>().changeTab(index),
                },
                icon: Icon(
                  icons[index],
                  size: AppSizes.responsiveHeight(context, AppSizes.iconLarge),
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).scaffoldBackgroundColor,
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
