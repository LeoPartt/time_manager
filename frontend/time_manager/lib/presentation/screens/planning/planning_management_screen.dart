
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_manager/core/constants/app_sizes.dart';
import 'package:time_manager/core/utils/extensions/context_extensions.dart';
import 'package:time_manager/domain/entities/planning.dart';
import 'package:time_manager/presentation/cubits/planning/planning_cubit.dart';
import 'package:time_manager/presentation/cubits/planning/planning_state.dart';
import 'package:time_manager/presentation/widgets/header.dart';
import 'package:time_manager/presentation/widgets/navbar.dart';

@RoutePage()
class PlanningManagementScreen extends StatefulWidget {
  final int userId;

  const PlanningManagementScreen({
    super.key,
    @PathParam('userId') required this.userId,
  });

  @override
  State<PlanningManagementScreen> createState() => _PlanningManagementScreenState();
}


class _PlanningManagementScreenState extends State<PlanningManagementScreen> {
  
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadDashboard();
      }
    });
  }

  void _loadDashboard() {
    final cubit = context.read<PlanningCubit>();

    cubit.loadUserPlannings(context, widget.userId);
    
  
    
  }
  
  @override
  Widget build(BuildContext context) {
    return _PlanningManagementView(userId: widget.userId);
  }
}

class _PlanningManagementView extends StatelessWidget {
  final int userId;

  const _PlanningManagementView({required this.userId});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion du planning'),
        backgroundColor: colorScheme.primary,
        elevation: 0,
      ),
      bottomNavigationBar: const NavBar(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddPlanningDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
        backgroundColor: colorScheme.primary,
        elevation: 4,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<PlanningCubit>().loadUserPlannings(context, userId);
          },
          child: BlocConsumer<PlanningCubit, PlanningState>(
            listener: (context, state) {
              state.whenOrNull(
                error: (msg) => context.showSnack(msg, isError: true),
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
                        'Chargement...',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                loaded: (plannings) => _buildContent(context, plannings, colorScheme),
                error: (msg) => _buildError(context, msg, colorScheme),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<Planning> plannings,
    ColorScheme colorScheme,
  ) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(AppSizes.p24),
      child: Column(
        children: [
          Header(label: 'Planning hebdomadaire'),
          SizedBox(height: AppSizes.p24),

          // Info card
          _buildInfoCard(context, plannings.length, colorScheme),
          SizedBox(height: AppSizes.p24),

          // Liste des plannings
          if (plannings.isEmpty)
            _buildEmptyState(context, colorScheme)
          else
            _buildPlanningList(context, plannings, colorScheme),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, int count, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primary.withValues(alpha:0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.r16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha:0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSizes.p12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha:0.2),
              borderRadius: BorderRadius.circular(AppSizes.r12),
            ),
            child: Icon(
              Icons.calendar_month,
              size: 32,
              color: Colors.white,
            ),
          ),
          SizedBox(width: AppSizes.p16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count jour${count > 1 ? 's' : ''} configuré${count > 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: AppSizes.p4),
                Text(
                  'sur 5 jours ouvrés de la semaine',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha:0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(AppSizes.p24),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha:0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_today_outlined,
                size: 64,
                color: colorScheme.primary,
              ),
            ),
            SizedBox(height: AppSizes.p24),
            Text(
              'Aucun planning configuré',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: AppSizes.p12),
            Text(
              'Commencez par ajouter des jours\nde travail pour cet utilisateur',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: AppSizes.p32),
            ElevatedButton.icon(
              onPressed: () => _showAddPlanningDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Ajouter un jour'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.p24,
                  vertical: AppSizes.p16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanningList(
    BuildContext context,
    List<Planning> plannings,
    ColorScheme colorScheme,
  ) {
    // Trier par jour de la semaine
    final sortedPlannings = List<Planning>.from(plannings)
      ..sort((a, b) => a.weekDay.compareTo(b.weekDay));

    return Column(
      children: sortedPlannings.map((planning) {
        return _buildPlanningCard(context, planning, colorScheme);
      }).toList(),
    );
  }

  Widget _buildPlanningCard(
    BuildContext context,
    Planning planning,
    ColorScheme colorScheme,
  ) {
    final weekDayName = _getWeekDayName(planning.weekDay);
    final weekDayColor = _getWeekDayColor(planning.weekDay);

    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.p16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.r16),
        border: Border.all(
          color: weekDayColor.withValues(alpha:0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha:0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // En-tête avec le jour
          Container(
            padding: EdgeInsets.all(AppSizes.p16),
            decoration: BoxDecoration(
              color: weekDayColor.withValues(alpha:0.1),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: weekDayColor.withValues(alpha:0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.calendar_today,
                    color: weekDayColor,
                    size: 20,
                  ),
                ),
                SizedBox(width: AppSizes.p12),
                Expanded(
                  child: Text(
                    weekDayName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: weekDayColor,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _showEditPlanningDialog(context, planning),
                  icon: const Icon(Icons.edit_outlined),
                  color: colorScheme.primary,
                  tooltip: 'Modifier',
                ),
                IconButton(
                  onPressed: () => _showDeleteConfirmation(context, planning),
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.red,
                  tooltip: 'Supprimer',
                ),
              ],
            ),
          ),

          // Horaires
          Padding(
            padding: EdgeInsets.all(AppSizes.p16),
            child: Row(
              children: [
                Expanded(
                  child: _buildTimeInfo(
                    context,
                    'Arrivée',
                    planning.startTime,
                    Icons.login,
                    Colors.green,
                  ),
                ),
                SizedBox(width: AppSizes.p16),
                Expanded(
                  child: _buildTimeInfo(
                    context,
                    'Départ',
                    planning.endTime,
                    Icons.logout,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ),

          // Durée totale
          Container(
            padding: EdgeInsets.all(AppSizes.p12),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha:0.3),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(14),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: colorScheme.primary,
                ),
                SizedBox(width: AppSizes.p8),
                Text(
                  'Durée : ${_calculateDuration(planning.startTime, planning.endTime)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInfo(
    BuildContext context,
    String label,
    String time,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(AppSizes.r12),
        border: Border.all(
          color: color.withValues(alpha:0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          SizedBox(height: AppSizes.p8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: AppSizes.p4),
          Text(
            time,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String msg, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.p24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: colorScheme.error),
            SizedBox(height: AppSizes.p16),
            Text(
              'Erreur',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.error,
              ),
            ),
            SizedBox(height: AppSizes.p8),
            Text(
              msg,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: AppSizes.p24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<PlanningCubit>().loadUserPlannings(context, userId);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPlanningDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<PlanningCubit>(),
        child: _PlanningDialog(userId: userId),
      ),
    );
  }

  void _showEditPlanningDialog(BuildContext context, Planning planning) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<PlanningCubit>(),
        child: _PlanningDialog(
          userId: userId,
          planning: planning,
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Planning planning) {
    final weekDayName = _getWeekDayName(planning.weekDay);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: AppSizes.p12),
            const Text('Confirmer la suppression'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Êtes-vous sûr de vouloir supprimer le planning du :',
              style: TextStyle(color: Colors.grey[700]),
            ),
            SizedBox(height: AppSizes.p12),
            Container(
              padding: EdgeInsets.all(AppSizes.p12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha:0.1),
                borderRadius: BorderRadius.circular(AppSizes.r8),
                border: Border.all(color: Colors.red.withValues(alpha:0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.red, size: 20),
                  SizedBox(width: AppSizes.p8),
                  Text(
                    weekDayName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSizes.p12),
            Text(
              'Cette action est irréversible.',
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
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<PlanningCubit>().deletePlanning(
                context,
                userId: userId,
                planningId: planning.id,
              );
              context.showSnack('Planning supprimé avec succès');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  String _calculateDuration(String start, String end) {
    try {
      final startParts = start.split(':');
      final endParts = end.split(':');

      final startMinutes = int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
      final endMinutes = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);

      final durationMinutes = endMinutes - startMinutes;
      final hours = durationMinutes ~/ 60;
      final minutes = durationMinutes % 60;

      if (minutes == 0) {
        return '${hours}h';
      }
      return '${hours}h${minutes.toString().padLeft(2, '0')}';
    } catch (e) {
      return '-';
    }
  }

  String _getWeekDayName(int weekDay) {
    const days = [
      'Lundi',
      'Mardi',
      'Mercredi',
      'Jeudi',
      'Vendredi',
    ];
    return days[weekDay];
  }

  Color _getWeekDayColor(int weekDay) {
    const colors = [
      Colors.blue,      // Lundi
      Colors.green,     // Mardi
      Colors.orange,    // Mercredi
      Colors.purple,    // Jeudi
      Colors.teal,      // Vendredi
      Colors.indigo,    // Samedi
      Colors.red,       // Dimanche
    ];
    return colors[weekDay];
  }
}

// Dialog de création/édition
class _PlanningDialog extends StatefulWidget {
  final int userId;
  final Planning? planning;

  const _PlanningDialog({
    required this.userId,
    this.planning,
  });

  @override
  State<_PlanningDialog> createState() => _PlanningDialogState();
}

class _PlanningDialogState extends State<_PlanningDialog> {
  int _selectedWeekDay = 0;
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 17, minute: 30);

  @override
  void initState() {
    super.initState();
    if (widget.planning != null) {
      _selectedWeekDay = widget.planning!.weekDay;
      _startTime = _parseTime(widget.planning!.startTime);
      _endTime = _parseTime(widget.planning!.endTime);
    }
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEdit = widget.planning != null;

    return AlertDialog(
      title: Row(
        children: [
          Icon(
            isEdit ? Icons.edit : Icons.add,
            color: colorScheme.primary,
          ),
          SizedBox(width: AppSizes.p12),
          Text(isEdit ? 'Modifier le planning' : 'Ajouter un planning'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Sélection du jour
            Container(
              padding: EdgeInsets.all(AppSizes.p12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withValues(alpha:0.3)),
                borderRadius: BorderRadius.circular(AppSizes.r12),
              ),
              child: DropdownButtonFormField<int>(
                initialValue: _selectedWeekDay,
                decoration: InputDecoration(
                  labelText: 'Jour de la semaine',
                  prefixIcon: Icon(
                    Icons.calendar_today,
                    color: colorScheme.primary,
                  ),
                  border: InputBorder.none,
                ),
                items: List.generate(5, (index) {
                  return DropdownMenuItem(
                    value: index,
                    child: Text(_getWeekDayName(index)),
                  );
                }),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedWeekDay = value);
                  }
                },
              ),
            ),

            SizedBox(height: AppSizes.p20),

            // Heure de début
            _buildTimeSelector(
              context,
              label: 'Heure d\'arrivée',
              icon: Icons.login,
              color: Colors.green,
              time: _startTime,
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: _startTime,
                  helpText: 'Sélectionner l\'heure d\'arrivée',
                );
                if (time != null) {
                  setState(() => _startTime = time);
                }
              },
            ),

            SizedBox(height: AppSizes.p16),

            // Heure de fin
            _buildTimeSelector(
              context,
              label: 'Heure de départ',
              icon: Icons.logout,
              color: Colors.orange,
              time: _endTime,
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: _endTime,
                  helpText: 'Sélectionner l\'heure de départ',
                );
                if (time != null) {
                  setState(() => _endTime = time);
                }
              },
            ),

            SizedBox(height: AppSizes.p20),

            // Aperçu de la durée
            Container(
              padding: EdgeInsets.all(AppSizes.p16),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha:0.3),
                borderRadius: BorderRadius.circular(AppSizes.r12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.access_time,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                  SizedBox(width: AppSizes.p8),
                  Text(
                    'Durée : ${_calculateDuration()}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            if (isEdit) {
              context.read<PlanningCubit>().updatePlanning(
                context,
                userId: widget.userId,
                planningId: widget.planning!.id,
                weekDay: _selectedWeekDay,
                startTime: _formatTimeOfDay(_startTime),
                endTime: _formatTimeOfDay(_endTime),
              );
            } else {
              context.read<PlanningCubit>().createPlanning(
                context,
                userId: widget.userId,
                weekDay: _selectedWeekDay,
                startTime: _formatTimeOfDay(_startTime),
                endTime: _formatTimeOfDay(_endTime),
              );
            }
            Navigator.pop(context);
            context.showSnack(
              isEdit ? 'Planning modifié avec succès !' : 'Planning créé avec succès !',
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
          ),
          child: Text(isEdit ? 'Modifier' : 'Créer'),
        ),
      ],
    );
  }

  Widget _buildTimeSelector(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.r12),
      child: Container(
        padding: EdgeInsets.all(AppSizes.p16),
        decoration: BoxDecoration(
          color: color.withValues(alpha:0.1),
          borderRadius: BorderRadius.circular(AppSizes.r12),
          border: Border.all(color: color.withValues(alpha:0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            SizedBox(width: AppSizes.p12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: AppSizes.p4),
                  Text(
                    time.format(context),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  String _calculateDuration() {
    final startMinutes = _startTime.hour * 60 + _startTime.minute;
    final endMinutes = _endTime.hour * 60 + _endTime.minute;
    final durationMinutes = endMinutes - startMinutes;

    if (durationMinutes < 0) return 'Invalide';

    final hours = durationMinutes ~/ 60;
    final minutes = durationMinutes % 60;

    if (minutes == 0) {
      return '${hours}h';
    }
    return '${hours}h${minutes.toString().padLeft(2, '0')}';
  }

  String _getWeekDayName(int weekDay) {
    const days = [
      'Lundi',
      'Mardi',
      'Mercredi',
      'Jeudi',
      'Vendredi',
      'Samedi',
      'Dimanche',
    ];
    return days[weekDay];
  }
}