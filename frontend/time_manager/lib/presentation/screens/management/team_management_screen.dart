
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/core/constants/app_colors.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/core/utils/extensions/context_extensions.dart';
import 'package:time_manager/core/widgets/app_button.dart';
import 'package:time_manager/core/widgets/app_card.dart';
import 'package:time_manager/domain/entities/team/team.dart';
import 'package:time_manager/domain/entities/user/user.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/cubits/team/team_cubit.dart';
import 'package:time_manager/presentation/cubits/team/team_state.dart';
import 'package:time_manager/presentation/cubits/user/user_cubit.dart';
import 'package:time_manager/presentation/cubits/user/user_state.dart';
import 'package:time_manager/presentation/routes/app_router.dart';
import 'package:time_manager/presentation/widgets/header.dart';
import 'package:time_manager/presentation/widgets/loading_state_widget.dart';
import 'package:time_manager/presentation/widgets/navbar.dart';

@RoutePage()
class TeamManagementScreen extends StatefulWidget {
  final Team team;
  
  const TeamManagementScreen({
    super.key,
    required this.team,
  });

  @override
  State<TeamManagementScreen> createState() => _TeamManagementScreenState();
}

class _TeamManagementScreenState extends State<TeamManagementScreen> {
  List<User> _allUsers = [];
  bool _isAddingMember = false;
  String _query = '';
  int? _managerId;

  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().getUsers();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeamCubit>().getTeam(widget.team.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final isTablet = context.screenWidth >= 600;

    return MultiBlocListener(
      listeners: [
        BlocListener<UserCubit, UserState>(
          listener: (context, userState) {
            userState.whenOrNull(
              listLoaded: (users) {
                if (mounted) {
                  setState(() => _allUsers = users);
                }
              },
            );
          },
        ),
        BlocListener<TeamCubit, TeamState>(
          listener: (context, state) {
            state.whenOrNull(
              loaded: (team, managerId) {
                if (mounted) {
                  setState(() {
                    _managerId = managerId;
                  });
                }

                if (mounted && _isAddingMember) {
                  setState(() {});
                }
              },
              error: (msg) => context.showError(msg),
              initial: () => context.router.push(const ManagementRoute()),
            );
          },
        ),
      ],
      child: Scaffold(
        bottomNavigationBar: const NavBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppSizes.p16),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isTablet ? 800 : double.infinity,
                ),
                child: Column(
                  children: [
                    Header(
                      label: tr.teamManagement,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => context.router.pop(),
                      ),
                    ),
                    
                    SizedBox(height: AppSizes.p24),

                    BlocBuilder<TeamCubit, TeamState>(
                      builder: (context, state) {
                        return state.maybeWhen(
                          loading: () => const LoadingStateWidget(),
                          error: (msg) => Center(
                            child: Text(
                              msg,
                              style: TextStyle(color: AppColors.error),
                            ),
                          ),
                          loaded: (team) => _buildTeamContent(context, team, tr),
                          orElse: () => const LoadingStateWidget(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamContent(BuildContext context, Team team, AppLocalizations tr) {
    final members = team.members;
    final colorScheme = context.colorScheme;

    return Column(
      children: [
        // Team Header
        AppCard(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.p20),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppSizes.p16),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(AppSizes.r12),
                  ),
                  child: Icon(
                    Icons.group,
                    size: 32,
                    color: colorScheme.primary,
                  ),
                ),
                
                SizedBox(width: AppSizes.p16),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        team.name,
                        style: TextStyle(
                          fontSize: AppSizes.textXl,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: AppSizes.p4),
                      Text(
                        '${members.length} ${tr.members}',
                        style: TextStyle(
                          fontSize: AppSizes.textSm,
                          color: colorScheme.onSurface.withValues(alpha:0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: AppSizes.p24),

        // Members List
        AppCard(
          child: Container(
            constraints: const BoxConstraints(minHeight: 300),
            child: members.isEmpty
                ? Padding(
                    padding: EdgeInsets.all(AppSizes.p32),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 64,
                            color: colorScheme.onSurface.withValues(alpha:0.3),
                          ),
                          SizedBox(height: AppSizes.p16),
                          Text(
                            tr.noMembers,
                            style: TextStyle(
                              fontSize: AppSizes.textLg,
                              color: colorScheme.onSurface.withValues(alpha:0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: members.length,
                    separatorBuilder: (_, _) => Divider(
                      color: colorScheme.outline.withValues(alpha:0.2),
                      height: 1,
                    ),
                    itemBuilder: (context, index) {
                      final member = members[index];
                      return ListTile(
                      
                        title: Text(
                          '${member.firstName} ${member.lastName}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        subtitle: Text(
                          member.email,
                          style: TextStyle(
                            fontSize: AppSizes.textSm,
                            color: colorScheme.onSurface.withValues(alpha:0.6),
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () => _confirmRemoveMember(
                            context,
                            team,
                            member,
                            tr,
                          ),
                          icon: Icon(
                            Icons.remove_circle_outline,
                            color: AppColors.error,
                          ),
                          tooltip: tr.removeMember,
                        ),
                      );
                    },
                  ),
          ),
        ),

        SizedBox(height: AppSizes.p24),

        // Action Buttons
        Row(
          children: [
            Expanded(
              child: AppButton(
                label: _isAddingMember ? tr.cancel : tr.addMembers,
                onPressed: () {
                  setState(() {
                    _isAddingMember = !_isAddingMember;
                    _query = '';
                  });
                },
                icon: _isAddingMember ? Icons.close : Icons.person_add,
              ),
            ),
            
            SizedBox(width: AppSizes.p16),
            
            Expanded(
              child: AppDangerButton(
                label: tr.deleteTeam,
                onPressed: () => _confirmDeleteTeam(context, team, tr),
                icon: Icons.delete_outline,
              ),
            ),
          ],
        ),

        if (_isAddingMember) ...[
          SizedBox(height: AppSizes.p24),
          _buildAddMemberPanel(context, team, tr),
        ],
      ],
    );
  }

  Widget _buildAddMemberPanel(BuildContext context, Team team, AppLocalizations tr) {
    final colorScheme = context.colorScheme;
    final teamMemberIds = team.members.map((m) => m.id).toSet();

    final filteredUsers = _allUsers
        .where((u) => !teamMemberIds.contains(u.id))
        .where((u) {
          final q = _query.toLowerCase();
          return q.isEmpty ||
              u.firstName.toLowerCase().contains(q) ||
              u.lastName.toLowerCase().contains(q) ||
              u.email.toLowerCase().contains(q);
        })
        .toList();

    return AppCard(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 400),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(AppSizes.p16),
              child: TextField(
                onChanged: (v) => setState(() => _query = v.trim()),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: tr.searchUser,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.r12),
                  ),
                ),
              ),
            ),
            
            Divider(color: colorScheme.outline.withValues(alpha:0.2)),
            
            Expanded(
              child: filteredUsers.isEmpty
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppSizes.p24),
                        child: Text(
                          tr.noUsersFound,
                          style: TextStyle(
                            color: colorScheme.onSurface.withValues(alpha:0.6),
                          ),
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: filteredUsers.length,
                      separatorBuilder: (_, _) => Divider(
                        color: colorScheme.outline.withValues(alpha:0.2),
                        height: 1,
                      ),
                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];
                        return ListTile(
                        
                          title: Text(
                            '${user.firstName} ${user.lastName}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            user.email,
                            style: TextStyle(fontSize: AppSizes.textSm),
                          ),
                          trailing: Icon(
                            Icons.add_circle_outline,
                            color: colorScheme.primary,
                          ),
                          onTap: () {
                            context.read<TeamCubit>().addMember(team.id, user.id);
                            setState(() => _isAddingMember = false);
                            context.showSuccess(tr.memberAddedSuccess);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmRemoveMember(
    BuildContext context,
    Team team,
    User member,
    AppLocalizations tr,
  ) async {
    final confirmed = await context.showConfirmDialog(
      title: tr.removeMember,
      message: '${tr.confirmRemoveMember} ${member.firstName} ${member.lastName} ?',
      isDangerous: true,
      confirmText: tr.remove,
    );

    if (confirmed && context.mounted) {
      context.read<TeamCubit>().removeMember(team.id, member.id);
      context.showSuccess(tr.memberRemovedSuccess);
    }
  }

  Future<void> _confirmDeleteTeam(
    BuildContext context,
    Team team,
    AppLocalizations tr,
  ) async {
    final confirmed = await context.showConfirmDialog(
      title: tr.deleteTeam,
      message: tr.confirmDeleteTeam,
      isDangerous: true,
      confirmText: tr.delete,
    );

    if (confirmed && context.mounted) {
      context.read<TeamCubit>().deleteTeam(team.id);
      context.showSuccess(tr.teamDeletedSuccess);
    }
  }
}