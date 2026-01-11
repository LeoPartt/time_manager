
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/core/utils/extensions/context_extensions.dart';
import 'package:time_manager/domain/entities/user/user.dart';
import 'package:time_manager/domain/entities/team/team.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/cubits/user/user_cubit.dart';
import 'package:time_manager/presentation/cubits/user/user_state.dart';
import 'package:time_manager/presentation/cubits/team/team_cubit.dart';
import 'package:time_manager/presentation/cubits/team/team_state.dart';

class AppSearchBar extends StatefulWidget {
  final bool onlyUsers;
  final int? currentUserId;
  final Function(User)? onUserSelected;
  final Function(Team)? onTeamSelected;
  final String? customHint;

  const AppSearchBar({
    super.key,
    this.onlyUsers = false,
    this.currentUserId,
    this.onUserSelected,
    this.onTeamSelected,
    this.customHint,
  });

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<User> _allUsers = [];
  List<Team> _allTeams = [];
  String _query = '';
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().getUsers();
    if (!widget.onlyUsers) {
      context.read<TeamCubit>().getTeams();
    }
    
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final colorScheme = context.colorScheme;
    final isTablet = context.screenWidth >= 600;
    
    final width = AppSizes.responsiveWidth(
      context,
      isTablet ? 400 : context.screenWidth * 0.9,
    );

    final lowerQuery = _query.toLowerCase();
    final filteredUsers = _allUsers.where((u) =>
      u.firstName.toLowerCase().contains(lowerQuery) ||
      u.lastName.toLowerCase().contains(lowerQuery) ||
      u.email.toLowerCase().contains(lowerQuery)
    ).toList();

    final filteredTeams = widget.onlyUsers
        ? <Team>[]
        : _allTeams.where((t) => 
            t.name.toLowerCase().contains(lowerQuery)
          ).toList();

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
        if (!widget.onlyUsers)
          BlocListener<TeamCubit, TeamState>(
            listener: (context, state) {
              state.whenOrNull(
                loadedTeams: (teams) => setState(() => _allTeams = teams),
              );
            },
          ),
      ],
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: width,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(AppSizes.r16),
          border: Border.all(
            color: _isFocused 
                ? colorScheme.primary 
                : colorScheme.outline.withValues(alpha:0.2),
            width: _isFocused ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha:_isFocused ? 0.2 : 0.1),
              blurRadius: _isFocused ? 16 : 8,
              offset: Offset(0, _isFocused ? 4 : 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Barre de recherche
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.p16,
                vertical: AppSizes.p8,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search_rounded,
                    color: _isFocused 
                        ? colorScheme.primary 
                        : colorScheme.onSurface.withValues(alpha:0.5),
                    size: 24,
                  ),
                  SizedBox(width: AppSizes.p12),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      autofocus: widget.onlyUsers,
                      onChanged: (value) => setState(() => _query = value.trim()),
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: AppSizes.responsiveText(context, AppSizes.textMd),
                      ),
                      decoration: InputDecoration(
                        hintText: widget.customHint ?? 
                            (widget.onlyUsers 
                                ? tr.searchUser 
                                : tr.searchUsersOrTeams),
                        hintStyle: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha:0.4),
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  if (_query.isNotEmpty)
                    IconButton(
                      icon: Icon(
                        Icons.clear_rounded,
                        color: colorScheme.onSurface.withValues(alpha:0.5),
                      ),
                      onPressed: () {
                        _controller.clear();
                        setState(() => _query = '');
                      },
                      tooltip: tr.clear,
                    ),
                ],
              ),
            ),

            // Résultats
            if (_query.isNotEmpty)
              Container(
                constraints: const BoxConstraints(maxHeight: 350),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: colorScheme.outline.withValues(alpha:0.2),
                    ),
                  ),
                ),
                child: results.isEmpty
                    ? _buildEmptyState(context, tr)
                    : _buildResultsList(context, results, colorScheme, tr),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations tr) {
    final colorScheme = context.colorScheme;
    
    return Padding(
      padding: EdgeInsets.all(AppSizes.p24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 48,
            color: colorScheme.onSurface.withValues(alpha:0.3),
          ),
          SizedBox(height: AppSizes.p12),
          Text(
            widget.onlyUsers ? tr.noUserFound : tr.noResultsFound,
            style: TextStyle(
              fontSize: AppSizes.textMd,
              color: colorScheme.onSurface.withValues(alpha:0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList(
    BuildContext context,
    List<dynamic> results,
    ColorScheme colorScheme,
    AppLocalizations tr,
  ) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: results.length,
      separatorBuilder: (_, _) => Divider(
        height: 1,
        color: colorScheme.outline.withValues(alpha:0.1),
      ),
      itemBuilder: (context, index) {
        final item = results[index];
        final isUser = item is User;
        final isCurrentUser = widget.currentUserId != null && 
                               isUser && 
                               item.id == widget.currentUserId;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _handleItemTap(context, item, isUser),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.p16,
                vertical: AppSizes.p12,
              ),
              color: isCurrentUser 
                  ? colorScheme.primaryContainer.withValues(alpha:0.2)
                  : null,
              child: Row(
                children: [
                  // Avatar/Icône
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isCurrentUser
                          ? colorScheme.primary
                          : colorScheme.primaryContainer.withValues(alpha:0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isUser
                          ? Text(
                              item.firstName.substring(0, 1).toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isCurrentUser 
                                    ? Colors.white 
                                    : colorScheme.primary,
                                fontSize: AppSizes.textLg,
                              ),
                            )
                          : Icon(
                              Icons.group_rounded,
                              color: isCurrentUser 
                                  ? Colors.white 
                                  : colorScheme.primary,
                              size: 20,
                            ),
                    ),
                  ),
                  
                  SizedBox(width: AppSizes.p12),
                  
                  // Infos
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isUser 
                              ? '${item.firstName} ${item.lastName}'
                              : (item as Team).name,
                          style: TextStyle(
                            fontSize: AppSizes.textMd,
                            fontWeight: isCurrentUser 
                                ? FontWeight.bold 
                                : FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        if (isUser) ...[
                          SizedBox(height: 2),
                          Text(
                            item.email,
                            style: TextStyle(
                              fontSize: AppSizes.textSm,
                              color: colorScheme.onSurface.withValues(alpha:0.6),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ] else ...[
                          if ((item as Team).description != null) ...[
                            SizedBox(height: 2),
                            Text(
                              item.description!,
                              style: TextStyle(
                                fontSize: AppSizes.textSm,
                                color: colorScheme.onSurface.withValues(alpha:0.6),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                  
                  // Indicateur
                  Icon(
                    isCurrentUser 
                        ? Icons.check_circle_rounded 
                        : Icons.chevron_right_rounded,
                    color: isCurrentUser 
                        ? colorScheme.primary 
                        : colorScheme.onSurface.withValues(alpha:0.3),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleItemTap(BuildContext context, dynamic item, bool isUser) {
    // Fermer le clavier
    _focusNode.unfocus();
    
    if (isUser) {
      widget.onUserSelected?.call(item as User);
    } else {
      widget.onTeamSelected?.call(item as Team);
    }
  }
}