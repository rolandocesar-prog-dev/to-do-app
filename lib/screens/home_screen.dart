import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
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
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        title: const Text(
          'Mis Tareas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Botón de menú debug
          PopupMenuButton<String>(
            icon: const Icon(Icons.bug_report),
            onSelected: (value) {
              final taskProvider = Provider.of<TaskProvider>(
                context,
                listen: false,
              );
              switch (value) {
                case 'debug':
                  taskProvider.debugTasksState();
                  break;
                case 'clear':
                  _showClearDialog(context, taskProvider);
                  break;
                case 'test':
                  taskProvider.createTestTasks();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tareas de prueba creadas'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                  break;
              }
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'debug',
                    child: Row(
                      children: [
                        Icon(Icons.info, color: AppColors.primary),
                        SizedBox(width: 8),
                        Text('Debug Info'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'test',
                    child: Row(
                      children: [
                        Icon(Icons.science, color: AppColors.success),
                        SizedBox(width: 8),
                        Text('Crear Tareas de Prueba'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'clear',
                    child: Row(
                      children: [
                        Icon(Icons.delete_sweep, color: AppColors.error),
                        SizedBox(width: 8),
                        Text('Limpiar Todo'),
                      ],
                    ),
                  ),
                ],
          ),
        ],
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

          // Lista de tareas
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                if (taskProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                final tasks = taskProvider.tasks;

                if (tasks.isEmpty) {
                  String emptyMessage;
                  if (taskProvider.isShowingAll) {
                    emptyMessage = 'No hay tareas creadas';
                  } else {
                    switch (taskProvider.filterStatus) {
                      case TaskStatus.pending:
                        emptyMessage = 'No hay tareas pendientes';
                        break;
                      case TaskStatus.completed:
                        emptyMessage = 'No hay tareas completadas';
                        break;
                      case TaskStatus.cancelled:
                        emptyMessage = 'No hay tareas canceladas';
                        break;
                      default:
                        emptyMessage = 'No hay tareas en esta categoría';
                    }
                  }

                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.task_alt,
                          size: 80,
                          color: AppColors.darkGrey.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          emptyMessage,
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.darkGrey.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Botones de debug
                        Wrap(
                          spacing: 12,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => taskProvider.debugTasksState(),
                              icon: const Icon(Icons.info),
                              label: const Text('Debug Info'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.dark,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                taskProvider.createTestTasks();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Tareas de prueba creadas'),
                                    backgroundColor: AppColors.success,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.science),
                              label: const Text('Crear Pruebas'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.success,
                                foregroundColor: AppColors.light,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
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

  Widget _buildStatCard(String label, int count, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
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
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: AppColors.light, fontSize: 12),
        ),
      ],
    );
  }

  void _showClearDialog(BuildContext context, TaskProvider taskProvider) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Limpiar todas las tareas'),
            content: const Text(
              '¿Estás seguro de que quieres eliminar todas las tareas? Esta acción no se puede deshacer.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  taskProvider.clearAllTasks();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Todas las tareas han sido eliminadas'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                },
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
                child: const Text('Eliminar Todo'),
              ),
            ],
          ),
    );
  }
}
