import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/core/constants/app_colors.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/domain/entities/user.dart';
import 'package:time_manager/domain/entities/team.dart';
import 'package:time_manager/presentation/cubits/user/user_cubit.dart';
import 'package:time_manager/presentation/cubits/user/user_state.dart';
import 'package:time_manager/presentation/cubits/team/team_cubit.dart';
import 'package:time_manager/presentation/cubits/team/team_state.dart';
import 'package:time_manager/presentation/screens/management/team_management_screen.dart';
import 'package:time_manager/presentation/screens/management/user_detail_screen.dart';

class AppSearchBar extends StatefulWidget {
  const AppSearchBar({super.key});

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  final TextEditingController _controller = TextEditingController();
  List<User> _allUsers = [];
  List<Team> _allTeams = [];
  String _query = '';

  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().getUsers();
    context.read<TeamCubit>().getTeams();
  }

  @override
  Widget build(BuildContext context) {
    final width = AppSizes.responsiveWidth(context, 350);

 final lowerQuery = _query.toLowerCase();
final filteredUsers = _allUsers
    .where((u) =>
        u.firstName.toLowerCase().contains(lowerQuery) ||
        u.lastName.toLowerCase().contains(lowerQuery) ||
        u.email.toLowerCase().contains(lowerQuery))
    .toList();

final filteredTeams = _allTeams
    .where((t) => t.name.toLowerCase().contains(lowerQuery))
    .toList();

final results = [...filteredUsers, ...filteredTeams];


    return MultiBlocListener(
      listeners: [
        BlocListener<UserCubit, UserState>(
          listener: (context, state) {
            state.whenOrNull(
              listLoaded: (users) => setState(() => _allUsers = users),
            );
          },
        ),
        BlocListener<TeamCubit, TeamState>(
          listener: (context, state) {
            state.whenOrNull(
              loadedTeams: (teams) => setState(() => _allTeams = teams),
            );
          },
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Container global avec coins arrondis, qui s’ouvre en bas quand il y a des résultats
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: width,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(AppSizes.r24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Barre de recherche
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: _controller,
                    onChanged: (value) =>
                        setState(() { _query = value.trim(); 
                        print(_query);} ),
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize:
                          AppSizes.responsiveText(context, AppSizes.textLg),
                    ),
                    decoration: InputDecoration(
                      icon: Icon(Icons.search_rounded,
                          color: AppColors.textPrimary),
                      hintText: 'Search user or team...',
                      hintStyle: TextStyle(
                        color: AppColors.textPrimary.withValues(alpha: 0.6),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                // Résultats intégrés directement dans le container
                if (_query.isNotEmpty)
                  Container(
                    color: AppColors.accent.withValues(alpha: 0.95),
                    constraints: const BoxConstraints(maxHeight: 250),
                    child: results.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                _allTeams.toString(),
                                style: TextStyle(
                                  color: AppColors.textPrimary.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: results.length,
                            separatorBuilder: (_, _) => Divider(
                              height: 1,
                              color:
                                  AppColors.primary.withValues(alpha: 0.2),
                            ),
                            itemBuilder: (context, index) {
                              final item = results[index];
                              final isUser = item is User;

                              return ListTile(
                                leading: Icon(
                                  isUser ? Icons.person : Icons.group,
                                  color: AppColors.textPrimary,
                                ),
                                title: Text(
                                  isUser
                                      ? '${item.firstName} ${item.lastName}'
                                      : (item as Team).name,
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: isUser
                                    ? Text(
                                        item.email,
                                        style: TextStyle(
                                          color: AppColors.textPrimary
                                              .withValues(alpha: 0.7),
                                        ),
                                      )
                                    : Text(
                                        (item as Team).description ??
                                            'No description',
                                        style: TextStyle(
                                          color: AppColors.textPrimary
                                              .withValues(alpha: 0.7),
                                        ),
                                      ),
                                 onTap: () {
                                  if (isUser) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => UserDetailScreen(user: item),
                                      ),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => TeamManagementScreen(team: item as Team),
                                      ),
                                    );
                                  }
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
    );
  }
}
