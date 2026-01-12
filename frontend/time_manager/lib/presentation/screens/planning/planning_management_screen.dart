
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/core/utils/extensions/context_extensions.dart';
import 'package:time_manager/domain/entities/planning/planning.dart';
import 'package:time_manager/domain/entities/user/user.dart';
import 'package:time_manager/l10n/app_localizations.dart';
import 'package:time_manager/presentation/cubits/planning/planning_cubit.dart';
import 'package:time_manager/presentation/cubits/planning/planning_state.dart';
import 'package:time_manager/presentation/cubits/user/user_cubit.dart';
import 'package:time_manager/presentation/widgets/empty_state_widget.dart';
import 'package:time_manager/presentation/widgets/error_state_widget.dart';
import 'package:time_manager/presentation/widgets/header.dart';
import 'package:time_manager/presentation/widgets/loading_state_widget.dart';
import 'package:time_manager/presentation/widgets/navbar.dart';
import 'package:time_manager/presentation/widgets/planning_management/planning_dialog_widget.dart';
import 'package:time_manager/presentation/widgets/planning_management/planning_info_card_widget.dart';
import 'package:time_manager/presentation/widgets/planning_management/planning_list_widget.dart';
import 'package:time_manager/presentation/widgets/planning_management/user_search_bar_widget.dart';
import 'package:time_manager/presentation/widgets/planning_management/user_search_dialog_widget.dart';

@RoutePage()
class PlanningManagementScreen extends StatefulWidget {
  final int? userId;

  const PlanningManagementScreen({
    super.key,
    @PathParam('userId') this.userId,
  });

  @override
  State<PlanningManagementScreen> createState() =>
      _PlanningManagementScreenState();
}

class _PlanningManagementScreenState extends State<PlanningManagementScreen> {
  int? _selectedUserId;
  User? _selectedUser;

  @override
  void initState() {
    super.initState();
    _selectedUserId = widget.userId;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<UserCubit>().getUsers();
        if (_selectedUserId != null) {
          _loadPlanning(_selectedUserId!);
        }
      }
    });
  }

  void _loadPlanning(int userId) {
    context.read<PlanningCubit>().loadUserPlannings(context, userId);
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: context.read<UserCubit>()),
        BlocProvider.value(value: context.read<PlanningCubit>()),
      ],
      child: _PlanningManagementView(
        selectedUserId: _selectedUserId,
        selectedUser: _selectedUser,
        onUserSelected: (user) {
          setState(() {
            _selectedUserId = user.id;
            _selectedUser = user;
          });
          _loadPlanning(user.id);
        },
        onAddPlanning: _showAddPlanningDialog,
        tr: tr,
      ),
    );
  }

  void _showAddPlanningDialog() {
   
      final tr = AppLocalizations.of(context)!;
    if (_selectedUserId == null) return;

    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<PlanningCubit>(),
        child: PlanningDialogWidget(
          userId: _selectedUserId!,
          tr: tr,
        ),
      ),
    );
  }
}

class _PlanningManagementView extends StatelessWidget {
  final int? selectedUserId;
  final User? selectedUser;
  final Function(User) onUserSelected;
  final VoidCallback onAddPlanning;
  final AppLocalizations tr;

  const _PlanningManagementView({
    required this.selectedUserId,
    required this.selectedUser,
    required this.onUserSelected,
    required this.onAddPlanning,
    required this.tr,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final screenWidth = context.screenWidth;
    final isTablet = screenWidth >= 600;
    final isDesktop = screenWidth >= 1200;

    // ✅ Padding responsive
    final horizontalPadding = AppSizes.responsiveWidth(
      context,
      isDesktop ? AppSizes.p32 : (isTablet ? AppSizes.p24 : AppSizes.p16),
    );

    return Scaffold(
      bottomNavigationBar: const NavBar(),
      floatingActionButton: selectedUserId != null
          ? _buildFloatingActionButton(context, colorScheme, isTablet)
          : null,
      body: SafeArea(
        child: Column(
          children: [
            // ✅ Header avec padding responsive
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: AppSizes.responsiveHeight(context, AppSizes.p16),
              ),
              child: Header(
                label: tr.planningManagement,
              
              ),
            ),
            
            // ✅ User Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: UserSearchBarWidget(
                selectedUser: selectedUser,
                onSearchTap: () => _showUserSearchDialog(context),
                tr: tr,
              ),
            ),
            
            SizedBox(height: AppSizes.responsiveHeight(context, AppSizes.p16)),
            
            // ✅ Content avec contraintes max-width
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isDesktop ? 1200 : (isTablet ? 900 : double.infinity),
                  ),
                  child: selectedUserId == null
                      ? _buildSelectUserPrompt(context, colorScheme)
                      : _buildPlanningContent(context, colorScheme, horizontalPadding),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(
    BuildContext context,
    ColorScheme colorScheme,
    bool isTablet,
  ) {
    return FloatingActionButton.extended(
      onPressed: onAddPlanning,
      icon: Icon(
        Icons.add,
        size: isTablet ? 24 : 20,
      ),
      label: Text(
        tr.add,
        style: TextStyle(
          fontSize: isTablet ? AppSizes.textMd : AppSizes.textSm,
        ),
      ),
      backgroundColor: colorScheme.primary,
      elevation: 4,
    );
  }

  Widget _buildSelectUserPrompt(BuildContext context, ColorScheme colorScheme) {
    
    return Padding(
      padding: EdgeInsets.all(
        AppSizes.responsiveWidth(context, AppSizes.p24),
      ),
      child: EmptyStateWidget(
        icon: Icons.person_search,
        title: tr.selectUser,
        subtitle: tr.selectUserSubtitle,
        buttonLabel: tr.search,
        onButtonPressed: () => _showUserSearchDialog(context),
      ),
    );
  }

  Widget _buildPlanningContent(
    BuildContext context,
    ColorScheme colorScheme,
    double horizontalPadding,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<PlanningCubit>().loadUserPlannings(
              context,
              selectedUserId!,
            );
      },
      child: BlocConsumer<PlanningCubit, PlanningState>(
        listener: (context, state) {
          state.whenOrNull(
            error: (msg) => context.showError(msg),
          );
        },
        builder: (context, state) {
          return state.when(
            initial: () => LoadingStateWidget(message: tr.initializing),
            loading: () => LoadingStateWidget(message: tr.loading),
            loaded: (plannings) => _buildContentList(
              context,
              plannings,
              colorScheme,
              horizontalPadding,
            ),
            error: (msg) => ErrorStateWidget(
              message: msg,
              onRetry: () {
                if (selectedUserId != null) {
                  context.read<PlanningCubit>().loadUserPlannings(
                        context,
                        selectedUserId!,
                      );
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildContentList(
    BuildContext context,
    List<Planning> plannings,
    ColorScheme colorScheme,
    double horizontalPadding,
  ) {
    final isTablet = context.screenWidth >= 600;
    final isDesktop = context.screenWidth >= 1200;

    // ✅ Padding responsive
    final contentPadding = AppSizes.responsiveWidth(
      context,
      isDesktop ? AppSizes.p32 : (isTablet ? AppSizes.p24 : AppSizes.p16),
    );

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(contentPadding),
      child: Column(
        children: [
          // ✅ Info Card responsive
          PlanningInfoCardWidget(
            planningCount: plannings.length,
            colorScheme: colorScheme,
            tr: tr,
          ),
          
          SizedBox(
            height: AppSizes.responsiveHeight(
              context,
              isTablet ? AppSizes.p32 : AppSizes.p24,
            ),
          ),
          
          // ✅ Content
          if (plannings.isEmpty)
            EmptyStateWidget(
              icon: Icons.calendar_today_outlined,
              title: tr.noPlanningConfigured,
              subtitle: tr.noPlanningSubtitle,
              buttonLabel: tr.addDay,
              onButtonPressed: onAddPlanning,
            )
          else
            _buildPlanningList(
              context,
              plannings,
              colorScheme,
              isTablet,
              isDesktop,
            ),
        ],
      ),
    );
  }

  Widget _buildPlanningList(
    BuildContext context,
    List<Planning> plannings,
    ColorScheme colorScheme,
    bool isTablet,
    bool isDesktop,
  ) {
    // ✅ Grid responsive pour desktop/tablet
    if (isDesktop) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSizes.p16,
          mainAxisSpacing: AppSizes.p16,
          childAspectRatio: 2.5,
        ),
        itemCount: plannings.length,
        itemBuilder: (context, index) {
          final planning = plannings[index];
          return _buildPlanningCard(
            context,
            planning,
            colorScheme,
          );
        },
      );
    }

    // ✅ Liste pour mobile/tablet
    return PlanningListWidget(
      plannings: plannings,
      colorScheme: colorScheme,
      onEdit: (planning) => _showEditDialog(context, planning),
      onDelete: (planning) => _showDeleteConfirmation(context, planning),
      tr: tr,
    );
  }

  Widget _buildPlanningCard(
    BuildContext context,
    Planning planning,
    ColorScheme colorScheme,
  ) {
    return InkWell(
      onTap: () => _showEditDialog(context, planning),
      borderRadius: BorderRadius.circular(AppSizes.r16),
      child: Container(
        padding: EdgeInsets.all(AppSizes.p16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(AppSizes.r16),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha:0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha:0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: colorScheme.primary,
              size: 24,
            ),
            SizedBox(width: AppSizes.p12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getWeekDayName(planning.weekDay),
                    style: TextStyle(
                      fontSize: AppSizes.textLg,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: AppSizes.p4),
                  Text(
                    '${planning.startTime} - ${planning.endTime}',
                    style: TextStyle(
                      fontSize: AppSizes.textSm,
                      color: colorScheme.onSurface.withValues(alpha:0.6),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => _showDeleteConfirmation(context, planning),
              icon: Icon(
                Icons.delete_outline,
                color: colorScheme.error,
              ),
              tooltip: tr.delete,
            ),
          ],
        ),
      ),
    );
  }

  void _showUserSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<UserCubit>(),
        child: UserSearchDialogWidget(
          onUserSelected: (user) {
            onUserSelected(user);
            Navigator.pop(dialogContext);
          },
          currentUserId: selectedUserId,
          tr: tr,
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, Planning planning) {
    if (selectedUserId == null) return;

    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<PlanningCubit>(),
        child: PlanningDialogWidget(
          userId: selectedUserId!,
          planning: planning,
          tr: tr,
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(
    BuildContext context,
    Planning planning,
  ) async {
    if (selectedUserId == null) return;

    final confirmed = await context.showConfirmDialog(
      title: tr.confirmDelete,
      message: '${tr.confirmDeletePlanning} ${_getWeekDayName(planning.weekDay)} ?',
      isDangerous: true,
      confirmText: tr.delete,
    );

    if (confirmed && context.mounted) {
      context.read<PlanningCubit>().deletePlanning(
            context,
            userId: selectedUserId!,
            planningId: planning.id,
          );
      context.showSuccess(tr.planningDeletedSuccess);
    }
  }

  String _getWeekDayName(int weekDay) {
    final days = [
      tr.monday,
      tr.tuesday,
      tr.wednesday,
      tr.thursday,
      tr.friday,
    ];
    return days[weekDay];
  }
}