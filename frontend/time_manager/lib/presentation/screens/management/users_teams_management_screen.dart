
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/core/utils/extensions/context_extensions.dart';
import 'package:time_manager/domain/entities/team/team.dart';
import 'package:time_manager/domain/entities/user/user.dart';
import 'package:time_manager/initialization/locator.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/cubits/team/team_cubit.dart';
import 'package:time_manager/presentation/cubits/team/team_state.dart';
import 'package:time_manager/presentation/cubits/user/user_cubit.dart';
import 'package:time_manager/presentation/cubits/user/user_state.dart';
import 'package:time_manager/presentation/routes/app_router.dart';
import 'package:time_manager/presentation/widgets/header.dart';
import 'package:time_manager/presentation/widgets/navbar.dart';

@RoutePage()
class UsersTeamsManagementScreen extends StatelessWidget {
  final int? selectedUserId;
  final int? selectedTeamId;

  const UsersTeamsManagementScreen({
    super.key,
    @PathParam('selectedUserId') this.selectedUserId,
    @PathParam('selectedTeamId') this.selectedTeamId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => locator<UserCubit>()..getUsers(),
        ),
        BlocProvider(
          create: (context) => locator<TeamCubit>()..getTeams(),
        ),
      ],
      child: _UsersTeamsManagementView(
        selectedUserId: selectedUserId,
        selectedTeamId: selectedTeamId,
      ),
    );
  }
}

class _UsersTeamsManagementView extends StatefulWidget {
  final int? selectedUserId;
  final int? selectedTeamId;

  const _UsersTeamsManagementView({
    this.selectedUserId,
    this.selectedTeamId,
  });

  @override
  State<_UsersTeamsManagementView> createState() =>
      _UsersTeamsManagementViewState();
}

class _UsersTeamsManagementViewState extends State<_UsersTeamsManagementView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.selectedTeamId != null ? 1 : 0,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isTablet = context.screenWidth >= 600;

    return Scaffold(
      
      bottomNavigationBar: const NavBar(),
      body:SafeArea(
        child: Column(
          children: [
            // ✅ Header avec cohérence
            Padding(
              padding: EdgeInsets.all(AppSizes.p16),
              child: Header(
                label: tr.management,
                
              ),
            ),

            // ✅ Tabs avec design moderne
            Container(
              margin: EdgeInsets.symmetric(horizontal: AppSizes.p16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppSizes.r12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(AppSizes.r12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: colorScheme.onSurface.withValues(alpha: 0.6),
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.people, size: 20),
                        if (isTablet) ...[
                          SizedBox(width: AppSizes.p8),
                          Text(tr.users),
                        ],
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.group, size: 20),
                        if (isTablet) ...[
                          SizedBox(width: AppSizes.p8),
                          Text(tr.teams),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSizes.p16),

            // ✅ Contenu des tabs
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _UsersTab(selectedUserId: widget.selectedUserId),
                  _TeamsTab(selectedTeamId: widget.selectedTeamId),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ═══════════════════════════════════════════════════════════════
// 👥 ONGLET UTILISATEURS
// ═══════════════════════════════════════════════════════════════

class _UsersTab extends StatelessWidget {
  final int? selectedUserId;

  const _UsersTab({this.selectedUserId});

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<UserCubit>().getUsers();
      },
      child: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {
          state.whenOrNull(
            error: (msg) => context.showError(msg),
            deleted: () {
              context.showSuccess(tr.userDeletedSuccess);
              context.read<UserCubit>().getUsers();
            },
          );
        },
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: CircularProgressIndicator()),
            loading: () => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  SizedBox(height: AppSizes.p16),
                  Text(
                    tr.loadingUsers,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            loaded: (_) => const SizedBox(),
            listLoaded: (users) => _buildUsersList(context, users, colorScheme, tr),
            updated: (_) => const SizedBox(),
            deleted: () => const SizedBox(),
            error: (msg) => _buildError(context, msg, colorScheme, isUser: true, tr: tr),
          );
        },
      ),
    );
  }

  Widget _buildUsersList(
    BuildContext context,
    List<User> users,
    ColorScheme colorScheme,
    AppLocalizations tr,
  ) {
    final isTablet = context.screenWidth >= 600;
    final padding = AppSizes.responsiveWidth(
      context,
      isTablet ? AppSizes.p24 : AppSizes.p16,
    );

    if (users.isEmpty) {
      return _buildEmptyState(
        context,
        colorScheme,
        Icons.person_off,
        tr.noUsers,
        tr.noUsersSubtitle,
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(padding),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return _buildUserCard(context, user, colorScheme, tr);
      },
    );
  }

  Widget _buildUserCard(
    BuildContext context,
    User user,
    ColorScheme colorScheme,
    AppLocalizations tr,
  ) {
    final isTablet = context.screenWidth >= 600;

    return Container(
      margin: EdgeInsets.only(
        bottom: AppSizes.responsiveHeight(context, AppSizes.p12),
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.r16),
        border: Border.all(color: colorScheme.outline.withValues(alpha:0.2)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha:0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSizes.r16),
          onTap: () {
            context.pushRoute(DashboardRoute(userId: user.id));
          },
          child: Padding(
            padding: EdgeInsets.all(
              AppSizes.responsiveWidth(context, AppSizes.p16),
            ),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: isTablet ? 64 : 56,
                  height: isTablet ? 64 : 56,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha:0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      user.username.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        fontSize: isTablet ? 28 : 24,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppSizes.responsiveWidth(context, AppSizes.p16)),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.username,
                        style: TextStyle(
                          fontSize: isTablet ? 18 : 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: AppSizes.p4),
                      Text(
                        user.email,
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: AppSizes.p4),
                      Text(
                        '${user.firstName} ${user.lastName}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),

                // Actions
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: colorScheme.primary),
                  onSelected: (value) {
                    switch (value) {
                      case 'dashboard':
                        context.pushRoute(DashboardRoute(userId: user.id, showbutton: false));
                        break;
                      case 'planning':
                        context.pushRoute(PlanningCalendarRoute(userId: user.id));
                        break;
                   
                      case 'edit':
                        context.pushRoute(EditManagementUserRoute(user: user));
                        break;
                    
                       
                      case 'delete':
                        _showDeleteUserConfirmation(context, user, tr);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'dashboard',
                      child: Row(
                        children: [
                          const Icon(Icons.dashboard_outlined, size: 20),
                          const SizedBox(width: 12),
                          Text(tr.dashboard),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'planning',
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month, size: 20),
                          const SizedBox(width: 12),
                          Text(tr.planning),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit, size: 20),
                          const SizedBox(width: 12),
                          Text(tr.edit),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete, size: 20, color: Colors.red),
                          const SizedBox(width: 12),
                          Text(tr.delete, style: const TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteUserConfirmation(
    BuildContext context,
    User user,
    AppLocalizations tr,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: AppSizes.p12),
            Text(tr.confirmDelete),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tr.confirmDeleteUser),
            SizedBox(height: AppSizes.p12),
            Container(
              padding: EdgeInsets.all(AppSizes.p12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha:0.1),
                borderRadius: BorderRadius.circular(AppSizes.r8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.username,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSizes.p12),
            Text(
              tr.irreversibleAction,
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(tr.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<UserCubit>().removeAccount(context, user.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(tr.delete),
          ),
        ],
      ),
    );
  }

  Widget _buildError(
    BuildContext context,
    String msg,
    ColorScheme colorScheme, {
    required bool isUser,
    required AppLocalizations tr,
  }) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.p24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: colorScheme.error),
            SizedBox(height: AppSizes.p16),
            Text(
              tr.error,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.error,
              ),
            ),
            SizedBox(height: AppSizes.p8),
            Text(msg, textAlign: TextAlign.center),
            SizedBox(height: AppSizes.p24),
            ElevatedButton.icon(
              onPressed: () {
                if (isUser) {
                  context.read<UserCubit>().getUsers();
                } else {
                  context.read<TeamCubit>().getTeams();
                }
              },
              icon: const Icon(Icons.refresh),
              label: Text(tr.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    ColorScheme colorScheme,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(AppSizes.p24),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha:0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 64, color: colorScheme.primary),
            ),
            SizedBox(height: AppSizes.p24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSizes.p12),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// 🏢 ONGLET ÉQUIPES
// ═══════════════════════════════════════════════════════════════

class _TeamsTab extends StatelessWidget {
  final int? selectedTeamId;

  const _TeamsTab({this.selectedTeamId});

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<TeamCubit>().getTeams();
      },
      child: BlocConsumer<TeamCubit, TeamState>(
        listener: (context, state) {
          state.whenOrNull(
            error: (msg) => context.showError(msg),
          );
        },
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: CircularProgressIndicator()),
            loading: () => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  SizedBox(height: AppSizes.p16),
                  Text(
                    tr.loadingTeams,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            loaded: (_,_) => const SizedBox(),
            loadedTeams: (teams) => _buildTeamsList(context, teams, colorScheme, tr),
            error: (msg) => _buildError(context, msg, colorScheme, tr),
          );
        },
      ),
    );
  }

  Widget _buildTeamsList(
    BuildContext context,
    List<Team> teams,
    ColorScheme colorScheme,
    AppLocalizations tr,
  ) {
    final isTablet = context.screenWidth >= 600;
    final padding = AppSizes.responsiveWidth(
      context,
      isTablet ? AppSizes.p24 : AppSizes.p16,
    );

    if (teams.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(AppSizes.p24),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha:0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.group_off, size: 64, color: colorScheme.primary),
              ),
              SizedBox(height: AppSizes.p24),
              Text(
                tr.noTeams,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: AppSizes.p12),
              Text(
                tr.noTeamsSubtitle,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(padding),
      itemCount: teams.length,
      itemBuilder: (context, index) {
        final team = teams[index];
        return _buildTeamCard(context, team, colorScheme, tr);
      },
    );
  }

  Widget _buildTeamCard(
    BuildContext context,
    Team team,
    ColorScheme colorScheme,
    AppLocalizations tr,
  ) {
    final isTablet = context.screenWidth >= 600;

    return Container(
      margin: EdgeInsets.only(
        bottom: AppSizes.responsiveHeight(context, AppSizes.p12),
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.r16),
        border: Border.all(color: colorScheme.outline.withValues(alpha:0.2)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha:0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSizes.r16),
          onTap: () {
            context.pushRoute(TeamDashboardRoute(teamId: team.id));
          },
          child: Padding(
            padding: EdgeInsets.all(
              AppSizes.responsiveWidth(context, AppSizes.p16),
            ),
            child: Row(
              children: [
                // Icône
                Container(
                  width: isTablet ? 64 : 56,
                  height: isTablet ? 64 : 56,
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer.withValues(alpha:0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.group,
                    color: colorScheme.secondary,
                    size: isTablet ? 32 : 28,
                  ),
                ),
                SizedBox(width: AppSizes.responsiveWidth(context, AppSizes.p16)),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        team.name,
                        style: TextStyle(
                          fontSize: isTablet ? 18 : 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (team.description != null && team.description!.isNotEmpty) ...[
                        SizedBox(height: AppSizes.p4),
                        Text(
                          team.description!,
                          style: TextStyle(
                            fontSize: isTablet ? 14 : 13,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (team.members.isNotEmpty) ...[
                        SizedBox(height: AppSizes.p8),
                        Row(
                          children: [
                            Icon(Icons.people, size: 16, color: Colors.grey[600]),
                            SizedBox(width: AppSizes.p4),
                            Text(
                              '${team.members.length} ${team.members.length > 1 ? tr.members : tr.member}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // Actions
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: colorScheme.secondary),
                  onSelected: (value) {
                    switch (value) {
                      case 'dashboard':
                        context.pushRoute(TeamDashboardRoute(teamId: team.id));
                        break;
                      
                      case 'manage':
                        context.pushRoute(TeamManagementRoute(team: team));
                        break;
                      case 'delete':
                        _showDeleteTeamConfirmation(context, team, tr);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'dashboard',
                      child: Row(
                        children: [
                          const Icon(Icons.dashboard_outlined, size: 20),
                          const SizedBox(width: 12),
                          Text(tr.dashboard),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'manage',
                      child: Row(
                        children: [
                          const Icon(Icons.group_outlined, size: 20),
                          const SizedBox(width: 12),
                          Text(tr.manage),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                 
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete, size: 20, color: Colors.red),
                          const SizedBox(width: 12),
                          Text(tr.delete, style: const TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteTeamConfirmation(
    BuildContext context,
    Team team,
    AppLocalizations tr,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: AppSizes.p12),
            Text(tr.confirmDelete),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tr.confirmDeleteTeam),
            SizedBox(height: AppSizes.p12),
            Container(
              padding: EdgeInsets.all(AppSizes.p12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha:0.1),
                borderRadius: BorderRadius.circular(AppSizes.r8),
              ),
              child: Text(
                team.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
            SizedBox(height: AppSizes.p12),
            Text(
              tr.irreversibleAction,
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(tr.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<TeamCubit>().deleteTeam(team.id);
              context.showSuccess(tr.teamDeletedSuccess);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(tr.delete),
          ),
        ],
      ),
    );
  }

  Widget _buildError(
    BuildContext context,
    String msg,
    ColorScheme colorScheme,
    AppLocalizations tr,
  ) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.p24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: colorScheme.error),
            SizedBox(height: AppSizes.p16),
            Text(
              tr.error,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: AppSizes.p8),
            Text(msg, textAlign: TextAlign.center),
            SizedBox(height: AppSizes.p24),
            ElevatedButton.icon(
              onPressed: () => context.read<TeamCubit>().getTeams(),
              icon: const Icon(Icons.refresh),
              label: Text(tr.retry),
            ),
          ],
        ),
      ),
    );
  }
}