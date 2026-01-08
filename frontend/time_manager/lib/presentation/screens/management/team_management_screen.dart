import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/core/constants/app_colors.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/core/widgets/app_button.dart';
import 'package:time_manager/core/widgets/app_search_bar.dart';
import 'package:time_manager/domain/entities/team.dart';
import 'package:time_manager/domain/entities/user.dart';
import 'package:time_manager/presentation/cubits/team/team_cubit.dart';
import 'package:time_manager/presentation/cubits/team/team_state.dart';
import 'package:time_manager/presentation/cubits/user/user_cubit.dart';
import 'package:time_manager/presentation/cubits/user/user_state.dart';
import 'package:time_manager/presentation/routes/app_router.dart';
import 'package:time_manager/presentation/widgets/header.dart';
import 'package:time_manager/presentation/widgets/navbar.dart';

@RoutePage()
class TeamManagementScreen extends StatefulWidget {
  final Team team;
  const TeamManagementScreen({super.key, required this.team});

  @override
  State<TeamManagementScreen> createState() => _TeamManagementScreenState();
}

class _TeamManagementScreenState extends State<TeamManagementScreen> {
  List<User> _allUsers = [];
  bool _isAddingMember = false;
  String _query = '';

  @override
  void initState() {
    super.initState();

    context.read<UserCubit>().getUsers();

    /// 🔑 IMPORTANT : on recharge la team depuis le Cubit
    /// widget.team ne sert QUE pour l’id initial pas plus !! O_O
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeamCubit>().getTeam(widget.team.id);
    });
  }

  @override
  Widget build(BuildContext context) {
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

        /// ⚠️ SnackBar uniquement sur erreur
        BlocListener<TeamCubit, TeamState>(
          listener: (context, state) {
            state.whenOrNull(
              loaded: (_) {
                if (mounted && _isAddingMember) {
                  setState(() {}); // Pour rebuild après suppr
                }
              },
              error: (msg) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
                  content: Text(
                    "Erreur : $msg",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              initial: () {
                context.router.push(const ManagementRoute());
              },
            );
          }
        ),
      ],
      child: Scaffold(
        bottomNavigationBar: const NavBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.p16,
              vertical: AppSizes.p12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Header(label: "TEAM MANAGEMENT"),
                const SizedBox(height: 8),
                AppSearchBar(),
                const SizedBox(height: 16),

                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(AppSizes.r24),
                    ),
                    padding: const EdgeInsets.all(AppSizes.p20),
                    child: BlocBuilder<TeamCubit, TeamState>(
                      builder: (context, state) {
                        return state.maybeWhen(
                          loading: () => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          error: (msg) => Center(
                            child: Text(
                              "Erreur : $msg",
                              style:
                                  TextStyle(color: AppColors.textPrimary),
                            ),
                          ),
                          loaded: (team) =>
                              _buildTeamContent(context, team),
                          orElse: () => Center(
                            child: Text(
                              "Aucune équipe sélectionnée",
                              style:
                                  TextStyle(color: AppColors.textPrimary),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// --- UI principale ---
  Widget _buildTeamContent(BuildContext context, Team team) {
    final members = team.members; // 🔒 source unique

    return Column(
      children: [
        // HEADER TEAM (inchangé)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor:
                  AppColors.primary.withValues(alpha: 0.3),
              child: Icon(
                Icons.person,
                size: 32,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(AppSizes.r12),
              ),
              child: Text(
                team.name,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: AppSizes.textLg,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // LISTE MEMBRES
        Expanded(
          child: members.isEmpty
              ? Center(
                  child: Text(
                    "Aucun membre",
                    style:
                        TextStyle(color: AppColors.textPrimary),
                  ),
                )
              : ListView.separated(
                  itemCount: members.length,
                  separatorBuilder: (_, __) => Divider(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    height: 8,
                  ),
                  itemBuilder: (context, index) {
                    final member = members[index];
                    return Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person,
                                color: Colors.black87, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              '${member.firstName} ${member.lastName}',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () => context
                              .read<TeamCubit>()
                              .removeMember(team.id, member.id),
                          icon: const Icon(Icons.close_rounded,
                              color: Colors.redAccent),
                        ),
                      ],
                    );
                  },
                ),
        ),
        const SizedBox(height: 10),

        // BOUTONS
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            AppButton(
              label: _isAddingMember ? "Cancel" : "Add a new member",
              onPressed: () {
                setState(() {
                  _isAddingMember = !_isAddingMember;
                  _query = '';
                });
              },
            ),
            AppButton(label: "Delete", onPressed: 
              () async {
                final confirmed = await _confirmDelete(context);

                if (confirmed && mounted) {
                  context.read<TeamCubit>().deleteTeam(team.id);
                }
              }
            ),
          ],
        ),

        if (_isAddingMember) _buildAddMemberPanel(context, team),
      ],
    );
  }

  /// --- PANEL AJOUT ---
  Widget _buildAddMemberPanel(BuildContext context, Team team) {
  final teamMemberIds = team.members.map((m) => m.id).toSet();

  final filteredUsers = _allUsers
      .where((u) => !teamMemberIds.contains(u.id)) // 🔑 clé
      .where((u) {
        final q = _query.toLowerCase();
        return q.isEmpty ||
            u.firstName.toLowerCase().contains(q) ||
            u.lastName.toLowerCase().contains(q) ||
            u.email.toLowerCase().contains(q);
      })
      .toList();

    return Container(
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(AppSizes.r16),
      ),
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(maxHeight: 250),
      child: Column(
        children: [
          TextField(
            onChanged: (v) => setState(() => _query = v.trim()),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search_rounded),
              hintText: 'Search user...',
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: filteredUsers.length,
              separatorBuilder: (_, __) => Divider(
                color: AppColors.primary.withValues(alpha: 0.2),
                height: 1,
              ),
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return ListTile(
                  leading: const Icon(Icons.person,
                      color: Colors.white70, size: 20),
                  title: Text(
                    '${user.firstName} ${user.lastName}',
                    style:
                        TextStyle(color: AppColors.textPrimary),
                  ),
                  subtitle: Text(
                    user.email,
                    style: TextStyle(
                        color: AppColors.textPrimary
                            .withValues(alpha: 0.7)),
                  ),
                  onTap: () {
                    context
                        .read<TeamCubit>()
                        .addMember(team.id, user.id);
                    setState(() => _isAddingMember = false);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Future<bool> _confirmDelete(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete team'),
            content: const Text(
              'Are you sure you want to delete this team? This action is irreversible.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Delete'),
              ),
            ],
          );
        },
      ) ??
      false;
}
