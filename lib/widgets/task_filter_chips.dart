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
          child: Row(
            children: [
              // Filtro "Todas" (muestra pendientes + completadas + canceladas)
              _buildFilterChip(
                context,
                'Todas (${taskProvider.allTasks.length})',
                null,
                taskProvider.isShowingAll,
                () {
                  print('Filter: Showing all tasks');
                  taskProvider.showAllTasks();
                },
              ),
              const SizedBox(width: 8),
              // Filtro "Pendientes" (solo pendientes)
              _buildFilterChip(
                context,
                'Pendientes (${taskProvider.pendingCount})',
                TaskStatus.pending,
                taskProvider.filterStatus == TaskStatus.pending,
                () {
                  print('Filter: Showing pending tasks');
                  taskProvider.setFilter(TaskStatus.pending);
                },
              ),
              const SizedBox(width: 8),
              // Filtro "Completadas" (solo completadas)
              _buildFilterChip(
                context,
                'Completadas (${taskProvider.completedCount})',
                TaskStatus.completed,
                taskProvider.filterStatus == TaskStatus.completed,
                () {
                  print('Filter: Showing completed tasks');
                  taskProvider.setFilter(TaskStatus.completed);
                },
              ),
              const SizedBox(width: 8),
              // Filtro "Canceladas" (solo canceladas)
              _buildFilterChip(
                context,
                'Canceladas (${taskProvider.cancelledCount})',
                TaskStatus.cancelled,
                taskProvider.filterStatus == TaskStatus.cancelled,
                () {
                  print('Filter: Showing cancelled tasks');
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
    TaskStatus? status,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.light,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.dark : AppColors.darkGrey,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color:
            isSelected
                ? AppColors.primary
                : AppColors.darkGrey.withOpacity(0.3),
      ),
    );
  }
}
