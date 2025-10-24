import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../theme/app_theme.dart';

class TaskFilterChips extends StatelessWidget {
  const TaskFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              // Filtro "Todas"
              _buildFilterChip(
                context,
                'Todas',
                taskProvider.allTasks.length,
                null,
                taskProvider.isShowingAll,
                () {
                  taskProvider.showAllTasks();
                },
              ),
              const SizedBox(width: 8),
              // Filtro "Pendientes"
              _buildFilterChip(
                context,
                'Pendientes',
                taskProvider.pendingCount,
                TaskStatus.pending,
                taskProvider.filterStatus == TaskStatus.pending,
                () {
                  taskProvider.setFilter(TaskStatus.pending);
                },
              ),
              const SizedBox(width: 8),
              // Filtro "Completadas"
              _buildFilterChip(
                context,
                'Completas',
                taskProvider.completedCount,
                TaskStatus.completed,
                taskProvider.filterStatus == TaskStatus.completed,
                () {
                  taskProvider.setFilter(TaskStatus.completed);
                },
              ),
              const SizedBox(width: 8),
              // Filtro "Canceladas"
              _buildFilterChip(
                context,
                'Canceladas',
                taskProvider.cancelledCount,
                TaskStatus.cancelled,
                taskProvider.filterStatus == TaskStatus.cancelled,
                () {
                  taskProvider.setFilter(TaskStatus.cancelled);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label,
    int count,
    TaskStatus? status,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    final displayText = '$label ($count)';

    return FilterChip(
      label: Text(
        displayText,
        style: TextStyle(
          color: isSelected 
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.onSurface.withValues(alpha: 0.7),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.primary,
      backgroundColor: theme.colorScheme.surface,
      side: BorderSide(
        color:
            isSelected
                ? AppColors.primary
                : theme.colorScheme.onSurface.withValues(alpha: 0.3),
        width: 1,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}
