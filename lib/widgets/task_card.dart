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
              _TaskHeader(task: task),
              if (task.description.isNotEmpty) 
                _TaskDescription(task: task),
              const SizedBox(height: 12),
              _TaskActions(task: task),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskHeader extends StatelessWidget {
  final Task task;
  
  const _TaskHeader({required this.task});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            task.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              decoration: task.status == TaskStatus.completed
                  ? TextDecoration.lineThrough
                  : null,
            ),
          ),
        ),
        _StatusChip(status: task.status),
      ],
    );
  }
}

class _TaskDescription extends StatelessWidget {
  final Task task;
  
  const _TaskDescription({required this.task});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        task.description,
        style: TextStyle(
          color: AppColors.textSecondary,
          decoration: task.status == TaskStatus.completed
              ? TextDecoration.lineThrough
              : null,
        ),
      ),
    );
  }
}

class _TaskActions extends StatelessWidget {
  final Task task;
  
  const _TaskActions({required this.task});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TaskDate(task: task),
        const Spacer(),
        _TaskButtons(task: task),
      ],
    );
  }
}

class _TaskDate extends StatelessWidget {
  final Task task;
  
  const _TaskDate({required this.task});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Creada: ${dateFormat.format(task.createdAt)}',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        if (task.completedAt != null)
          Text(
            'Completada: ${dateFormat.format(task.completedAt!)} a las ${timeFormat.format(task.completedAt!)}',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.success,
            ),
          ),
      ],
    );
  }
}

class _TaskButtons extends StatelessWidget {
  final Task task;
  
  const _TaskButtons({required this.task});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (task.status == TaskStatus.pending) ...[
              _ActionButton(
                icon: Icons.check,
                color: AppColors.success,
                onPressed: () => taskProvider.updateTaskStatus(task.id, TaskStatus.completed),
              ),
              const SizedBox(width: 8),
              _ActionButton(
                icon: Icons.cancel,
                color: AppColors.error,
                onPressed: () => taskProvider.updateTaskStatus(task.id, TaskStatus.cancelled),
              ),
            ],
            const SizedBox(width: 8),
            _ActionButton(
              icon: Icons.delete,
              color: AppColors.error,
              onPressed: () => _showDeleteDialog(context, taskProvider),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, TaskProvider taskProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Tarea'),
        content: const Text('¿Estás seguro de que quieres eliminar esta tarea?'),
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
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  
  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: color),
      iconSize: 20,
    );
  }
}

class _StatusChip extends StatelessWidget {
  final TaskStatus status;
  
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color chipColor;
    String statusText;

    switch (status) {
      case TaskStatus.pending:
        chipColor = AppColors.warning;
        statusText = 'Pendiente';
        break;
      case TaskStatus.completed:
        chipColor = AppColors.success;
        statusText = 'Completada';
        break;
      case TaskStatus.cancelled:
        chipColor = AppColors.error;
        statusText = 'Cancelada';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chipColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: chipColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}