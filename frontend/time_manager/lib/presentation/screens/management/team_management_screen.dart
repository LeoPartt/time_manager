import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/core/constants/app_colors.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/core/widgets/app_button.dart';
import 'package:time_manager/core/widgets/app_search_bar.dart';
import 'package:time_manager/domain/entities/team.dart';
import 'package:time_manager/domain/entities/user.dart';
import 'package:time_manager/presentation/cubits/user/user_cubit.dart';
import 'package:time_manager/presentation/cubits/user/user_state.dart';
import 'package:time_manager/presentation/widgets/header.dart';
import 'package:time_manager/presentation/widgets/navbar.dart';

@RoutePage()
class TeamManagementScreen extends StatefulWidget {
  Team team;

  TeamManagementScreen({super.key, required this.team});

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
  }


  @override
  Widget build(BuildContext context) {
    final members = widget.team.members;

    return BlocListener<UserCubit, UserState>(
          listener: (context, state) {
            state.whenOrNull(
              listLoaded: (users) => setState(() => _allUsers = users),
            );
          },
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.p20, vertical: AppSizes.p20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor:
                                AppColors.primary.withValues(alpha: 0.3),
                            child: Icon(Icons.person,
                                size: 32, color: AppColors.textPrimary),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 12),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              borderRadius:
                                  BorderRadius.circular(AppSizes.r12),
                            ),
                            child: Text(
                              widget.team.name,
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

                      Expanded(
                        child: ListView.separated(
                          itemCount: members.length,
                          separatorBuilder: (_, __) => Divider(
                            color:
                                AppColors.primary.withValues(alpha: 0.2),
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
                                      '${member.firstName}  ${member.lastName}',
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () {
                                    // TODO: delete member
                                  },
                                  icon: const Icon(Icons.close_rounded,
                                      color: Colors.redAccent),
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 10),

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

                          AppButton(label: "Delete", onPressed: () {

                          })
                        ],
                      ),
                      if (_isAddingMember)
                        Container(
                          margin: const EdgeInsets.only(top: 12),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withValues(alpha: 0.95),
                            borderRadius: BorderRadius.circular(AppSizes.r16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(maxHeight: 250),
                          child: Column(
                            children: [
                              // champ de recherche
                              TextField(
                                onChanged: (v) => setState(() => _query = v.trim()),
                                style: TextStyle(color: AppColors.textPrimary),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.search_rounded),
                                  hintText: 'Search user...',
                                  hintStyle: TextStyle(
                                    color: AppColors.textPrimary.withValues(alpha: 0.6),
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // liste filtrée
                              Expanded(
                                child: ListView.separated(
                                  itemCount: _allUsers
                                      .where((u) =>
                                          _query.isEmpty ||
                                          u.firstName.toLowerCase().contains(_query.toLowerCase()) ||
                                          u.lastName.toLowerCase().contains(_query.toLowerCase()) ||
                                          u.email.toLowerCase().contains(_query.toLowerCase()))
                                      .length,
                                  separatorBuilder: (_, _) => Divider(
                                    color: AppColors.primary.withValues(alpha: 0.2),
                                    height: 1,
                                  ),
                                  itemBuilder: (context, index) {
                                    final filtered = _allUsers
                                        .where((u) =>
                                            _query.isEmpty ||
                                            u.firstName
                                                .toLowerCase()
                                                .contains(_query.toLowerCase()) ||
                                            u.lastName
                                                .toLowerCase()
                                                .contains(_query.toLowerCase()) ||
                                            u.email.toLowerCase().contains(_query.toLowerCase()))
                                        .toList();
                                    final user = filtered[index];
                                    return ListTile(
                                      leading:
                                          const Icon(Icons.person, color: Colors.white70, size: 20),
                                      title: Text(
                                        '${user.firstName} ${user.lastName}',
                                        style: TextStyle(color: AppColors.textPrimary),
                                      ),
                                      subtitle: Text(
                                        user.email,
                                        style: TextStyle(
                                            color: AppColors.textPrimary.withValues(alpha: 0.7)),
                                      ),
                                      onTap: () {
                                        final alreadyInTeam = widget.team.members.any((m) => m.id == user.id);

                                        if (alreadyInTeam) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.orangeAccent,
                                              content: Text(
                                                '${user.firstName} est déjà membre de ${widget.team.name}',
                                                style: const TextStyle(color: Colors.white),
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        setState(() {
                                          widget.team = widget.team.copyWith(
                                            members: [...widget.team.members, user],
                                          );
                                          _isAddingMember = false;
                                        });

                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            backgroundColor: AppColors.primary,
                                            content: Text(
                                              '${user.firstName} ajouté à ${widget.team.name}',
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
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
    )
     );
  }
}