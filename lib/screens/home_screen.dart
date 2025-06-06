import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../widgets/task_card.dart';
import '../widgets/task_filter_chips.dart';
import '../widgets/watermark_widget.dart';
import '../theme/app_theme.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WatermarkWidget(
      logoPath: 'assets/images/voz_liberal.png',
      opacity: 0.09,
      size: 550,
      alignment: Alignment.bottomCenter,
      rotated: false,
      child: Scaffold(
        backgroundColor: AppColors.lightGrey,
        appBar: AppBar(
          title: const Text(
            'Mis Tareas Liberales',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        body: Column(
          children: [
            // Panel de estadísticas
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.dark,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Consumer<TaskProvider>(
                builder: (context, taskProvider, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard(
                        'Pendientes',
                        taskProvider.pendingCount,
                        AppColors.warning,
                      ),
                      _buildStatCard(
                        'Completadas',
                        taskProvider.completedCount,
                        AppColors.success,
                      ),
                      _buildStatCard(
                        'Canceladas',
                        taskProvider.cancelledCount,
                        AppColors.error,
                      ),
                    ],
                  );
                },
              ),
            ),

            // Filtros
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TaskFilterChips(),
            ),

            const SizedBox(height: 16),

            // Lista de tareas
            Expanded(
              child: Consumer<TaskProvider>(
                builder: (context, taskProvider, child) {
                  if (taskProvider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  final tasks = taskProvider.tasks;

                  if (tasks.isEmpty) {
                    return _buildEmptyState(taskProvider);
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return TaskCard(task: tasks[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddTaskScreen()),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('Nueva Tarea'),
        ),
      ),
    );
  }

  Widget _buildEmptyState(TaskProvider taskProvider) {
    String emptyMessage;
    String emptySubtitle;

    if (taskProvider.isShowingAll) {
      emptyMessage = 'No hay tareas creadas';
      emptySubtitle = 'Crea tu primera tarea con el botón +';
    } else {
      switch (taskProvider.filterStatus) {
        case TaskStatus.pending:
          emptyMessage = 'No hay tareas pendientes';
          emptySubtitle = 'Todas las tareas están completadas o canceladas';
          break;
        case TaskStatus.completed:
          emptyMessage = 'No hay tareas completadas';
          emptySubtitle = 'Completa algunas tareas para verlas aquí';
          break;
        case TaskStatus.cancelled:
          emptyMessage = 'No hay tareas canceladas';
          emptySubtitle = 'Las tareas canceladas aparecerán aquí';
          break;
        default:
          emptyMessage = 'No hay tareas en esta categoría';
          emptySubtitle = 'Prueba otro filtro o crea nuevas tareas';
      }
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              taskProvider.isShowingAll ? Icons.task_alt : Icons.filter_alt,
              size: 80,
              color: AppColors.darkGrey.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.darkGrey.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              emptySubtitle,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.darkGrey.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, int count, Color color) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.light,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
