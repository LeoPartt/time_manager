import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/core/utils/role/role_manager.dart';
import 'package:time_manager/presentation/cubits/user/user_cubit.dart';
import 'package:time_manager/presentation/cubits/user/user_state.dart';

class RoleBasedWidget extends StatelessWidget {
  final UserRole requiredRole;
  final Widget child;
  final Widget? fallback;

  const RoleBasedWidget({
    super.key,
    required this.requiredRole,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return state.when(
          initial: () => fallback ?? const SizedBox(),
          loading: () => fallback ?? const SizedBox(),
          loaded: (user) {
            if (RoleManager.hasRole(user, requiredRole)) {
              return child;
            }
            return fallback ?? const SizedBox();
          },
          listLoaded: (_) => fallback ?? const SizedBox(),
          updated: (user) {
            if (RoleManager.hasRole(user, requiredRole)) {
              return child;
            }
            return fallback ?? const SizedBox();
          },
          deleted: () => fallback ?? const SizedBox(),
          error: (_) => fallback ?? const SizedBox(),
        );
      },
    );
  }
}