import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';
import '../screens/edit_task_screen.dart';
import '../utils/ui_utils.dart';

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
              color: Theme.of(context).colorScheme.onSurface,
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
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
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
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        if (task.completedAt != null)
          Text(
            'Completada: ${dateFormat.format(task.completedAt!)} a las ${timeFormat.format(task.completedAt!)}',
            style: TextStyle(
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
                icon: Icons.edit,
                color: AppColors.info,
                onPressed: () => _showEditConfirmation(context, taskProvider),
              ),
              const SizedBox(width: 8),
              _ActionButton(
                icon: Icons.check,
                color: AppColors.success,
                onPressed: () => _showCompleteConfirmation(context, taskProvider),
              ),
              const SizedBox(width: 8),
              _ActionButton(
                icon: Icons.cancel,
                color: AppColors.error,
                onPressed: () => _showCancelConfirmation(context, taskProvider),
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

  void _showEditConfirmation(BuildContext context, TaskProvider taskProvider) async {
    final confirmed = await UIUtils.showConfirmDialog(
      context,
      title: 'Editar Tarea',
      message: '¿Deseas editar esta tarea?',
      confirmText: 'Editar',
      cancelText: 'Cancelar',
      icon: Icons.edit_rounded,
      iconColor: AppColors.info,
    );

    if (confirmed == true && context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditTaskScreen(task: task),
        ),
      );
    }
  }

  void _showCompleteConfirmation(BuildContext context, TaskProvider taskProvider) async {
    final confirmed = await UIUtils.showConfirmDialog(
      context,
      title: 'Completar Tarea',
      message: '¿Marcar esta tarea como completada?',
      confirmText: 'Completar',
      cancelText: 'Cancelar',
      icon: Icons.check_circle_rounded,
      iconColor: AppColors.success,
    );

    if (confirmed == true && context.mounted) {
      taskProvider.updateTaskStatus(task.id, TaskStatus.completed);
      
      UIUtils.showCustomSnackBar(
        context,
        message: '¡Tarea completada!',
        type: SnackBarType.success,
      );
    }
  }

  void _showCancelConfirmation(BuildContext context, TaskProvider taskProvider) async {
    final confirmed = await UIUtils.showConfirmDialog(
      context,
      title: 'Cancelar Tarea',
      message: '¿Deseas cancelar esta tarea? No podrás reactivarla después.',
      confirmText: 'Cancelar Tarea',
      cancelText: 'Volver',
      icon: Icons.cancel_rounded,
      isDangerous: true,
    );

    if (confirmed == true && context.mounted) {
      taskProvider.updateTaskStatus(task.id, TaskStatus.cancelled);
      
      UIUtils.showCustomSnackBar(
        context,
        message: 'Tarea cancelada',
        type: SnackBarType.warning,
      );
    }
  }

  void _showDeleteDialog(BuildContext context, TaskProvider taskProvider) async {
    final confirmed = await UIUtils.showConfirmDialog(
      context,
      title: 'Eliminar Tarea',
      message: '¿Estás seguro de que deseas eliminar esta tarea? Esta acción no se puede deshacer.',
      confirmText: 'Eliminar',
      cancelText: 'Cancelar',
      icon: Icons.delete_rounded,
      isDangerous: true,
    );

    if (confirmed == true && context.mounted) {
      taskProvider.deleteTask(task.id);
      
      UIUtils.showCustomSnackBar(
        context,
        message: 'Tarea eliminada correctamente',
        type: SnackBarType.success,
      );
    }
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