import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../providers/theme_provider.dart';
import '../models/task.dart';
import '../widgets/task_card.dart';
import '../widgets/task_filter_chips.dart';
import '../theme/app_theme.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text(
            'Mis Tareas',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return IconButton(
                  onPressed: () => themeProvider.toggleTheme(),
                  icon: Icon(
                    themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  ),
                  tooltip: 'Cambiar tema (${themeProvider.themeModeName})',
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Panel de estadísticas optimizado
            const _StatsPanel(),
            
            // Filtros
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TaskFilterChips(),
            ),

            const SizedBox(height: 16),

            // Lista de tareas optimizada
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
                    return _EmptyState(taskProvider: taskProvider);
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
    );
  }

}

class _StatsPanel extends StatelessWidget {
  const _StatsPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatCard(
                label: 'Pendientes',
                count: taskProvider.pendingCount,
                color: AppColors.warning,
              ),
              _StatCard(
                label: 'Completadas',
                count: taskProvider.completedCount,
                color: AppColors.success,
              ),
              _StatCard(
                label: 'Canceladas',
                count: taskProvider.cancelledCount,
                color: AppColors.error,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  
  const _StatCard({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
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
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
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

class _EmptyState extends StatelessWidget {
  final TaskProvider taskProvider;
  
  const _EmptyState({required this.taskProvider});

  @override
  Widget build(BuildContext context) {
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
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              emptySubtitle,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

