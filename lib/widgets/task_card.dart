import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.dark,
                        decoration:
                            task.status == TaskStatus.completed
                                ? TextDecoration.lineThrough
                                : null,
                      ),
                    ),
                  ),
                  _buildStatusChip(),
                ],
              ),

              if (task.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  task.description,
                  style: TextStyle(
                    color: AppColors.darkGrey,
                    decoration:
                        task.status == TaskStatus.completed
                            ? TextDecoration.lineThrough
                            : null,
                  ),
                ),
              ],

              const SizedBox(height: 12),

              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: AppColors.darkGrey),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('dd/MM/yyyy HH:mm').format(task.createdAt),
                    style: TextStyle(fontSize: 12, color: AppColors.darkGrey),
                  ),
                  const Spacer(),
                  _buildActionButtons(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color color;
    String label;
    IconData icon;

    switch (task.status) {
      case TaskStatus.pending:
        color = AppColors.warning;
        label = 'Pendiente';
        icon = Icons.schedule;
        break;
      case TaskStatus.completed:
        color = AppColors.success;
        label = 'Completada';
        icon = Icons.check_circle;
        break;
      case TaskStatus.cancelled:
        color = AppColors.error;
        label = 'Cancelada';
        icon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (task.status == TaskStatus.pending) ...[
              _buildActionButton(
                icon: Icons.check,
                color: AppColors.success,
                onPressed:
                    () => taskProvider.updateTaskStatus(
                      task.id,
                      TaskStatus.completed,
                    ),
              ),
              const SizedBox(width: 8),
              _buildActionButton(
                icon: Icons.close,
                color: AppColors.error,
                onPressed:
                    () => taskProvider.updateTaskStatus(
                      task.id,
                      TaskStatus.cancelled,
                    ),
              ),
            ] else if (task.status != TaskStatus.pending) ...[
              _buildActionButton(
                icon: Icons.refresh,
                color: AppColors.warning,
                onPressed:
                    () => taskProvider.updateTaskStatus(
                      task.id,
                      TaskStatus.pending,
                    ),
              ),
            ],
            const SizedBox(width: 8),
            _buildActionButton(
              icon: Icons.delete,
              color: AppColors.error,
              onPressed: () => _showDeleteDialog(context, taskProvider),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, TaskProvider taskProvider) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Eliminar Tarea'),
            content: const Text(
              '¿Estás seguro de que quieres eliminar esta tarea?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  taskProvider.deleteTask(task.id);
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
                child: const Text('Eliminar'),
              ),
            ],
          ),
    );
  }
}
