import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/core/constants/app_colors.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/core/utils/accessibility_utils.dart';
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
      final backgroundColor =
        AccessibilityUtils.ensureContrast(context, colorScheme.secondary);
    final textColor =
        AccessibilityUtils.ensureContrast(context, colorScheme.secondary);

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
      child: Semantics(
                container: true,
        label: 'Search bar for users and teams',

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: width,
          decoration: BoxDecoration(
            color: colorScheme.secondary,
            borderRadius: BorderRadius.circular(AppSizes.r24),
            boxShadow: [
             BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Barre de recherche
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.p12),
                child: TextField(
                  controller: _controller,
                  onChanged: (value) =>
                      setState(() =>_query = value.trim()
                       ),
                  style: TextStyle(
                    color: textColor,
                    fontSize:
                        AppSizes.responsiveText(context, AppSizes.textLg),
                  ),
                  decoration: InputDecoration(
                    icon: Icon(Icons.search_rounded,
                        color: colorScheme.onSurface,),
                    hintText: 'Search user or team...',
                    hintStyle: TextStyle(
                      color:  colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
        
              // Résultats intégrés directement dans le container
              if (_query.isNotEmpty)
                Container(
                  color: backgroundColor.withValues(alpha: 0.95),
                  constraints: const BoxConstraints(maxHeight: 250),
                  child: results.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(AppSizes.p16),
                          child: Center(
                            child:  AccessibilityUtils.accessibleTextWidget(
                              context,
                              _allTeams.toString(),
                              baseSize: AppSizes.textMd,
                              color: textColor.withValues(alpha: 0.8),
                            ),
                           
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: results.length,
                          separatorBuilder: (_, _) => Divider(
                            height: 1,
                            color: colorScheme.primary.withValues(alpha: 0.2),
                          ),
                          itemBuilder: (context, index) {
                            final item = results[index];
                            final isUser = item is User;
                            final iconColor = AccessibilityUtils.ensureContrast(
                              context,
                              colorScheme.secondary,
                            );

        
                            return Semantics(
                              button: true,
                              label: isUser
                                  ? 'User ${item.firstName} ${item.lastName}'
                                  : 'Team ${(item as Team).name}',
                              child: ListTile(
                                leading: Icon(
                                  isUser ? Icons.person : Icons.group,
                                  color: iconColor,
                                ),
                                title: AccessibilityUtils.accessibleTextWidget(
                                  context,
                                  isUser
                                      ? '${item.firstName} ${item.lastName}'
                                      : (item as Team).name,
                                  baseSize: AppSizes.textLg,
                                  weight: FontWeight.w600,
                                  color: textColor,
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
                              )
                            );
                            },
                          ),
                  ),
              ],
            ),
          ),
      ),
    );
  }
}
