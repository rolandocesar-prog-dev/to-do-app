import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../widgets/task_card.dart';
import '../widgets/task_filter_chips.dart';
import '../widgets/watermark_widget.dart'; // ← AGREGAR ESTA LÍNEA
import '../theme/app_theme.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WatermarkWidget(
      // ← ENVOLVER CON WATERMARK
      logoPath: 'assets/images/voz_liberal.png', // ← RUTA CORRECTA
      opacity: 0.15, // TEMPORAL: Más visible para confirmar que funciona
      size: 240,
      alignment: Alignment.center,
      rotated: false,
      child: Scaffold(
        backgroundColor: AppColors.lightGrey,
        appBar: AppBar(
          title: const Text(
            'Mis Tareas Liberales',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            // Tu menú debug existente...
            PopupMenuButton<String>(
              icon: const Icon(Icons.bug_report),
              tooltip: 'Opciones de Debug',
              onSelected: (value) async {
                final taskProvider = Provider.of<TaskProvider>(
                  context,
                  listen: false,
                );
                switch (value) {
                  case 'debug':
                    taskProvider.debugTasksState();
                    break;
                  case 'reload':
                    await taskProvider.reloadTasks();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tareas recargadas desde storage'),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    }
                    break;
                  case 'clear':
                    _showClearDialog(context, taskProvider);
                    break;
                  case 'test':
                    await taskProvider.createTestTasks();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Tareas de prueba creadas: 1 pendiente, 1 completada, 1 cancelada',
                          ),
                          backgroundColor: AppColors.success,
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
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
                          Text('Ver Debug Info'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'reload',
                      child: Row(
                        children: [
                          Icon(Icons.refresh, color: AppColors.warning),
                          SizedBox(width: 8),
                          Text('Recargar desde Storage'),
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
    ); // ← CERRAR WatermarkWidget aquí
  }

  // Resto de métodos existentes...
  Widget _buildEmptyState(TaskProvider taskProvider) {
    // Tu código existente del empty state...
    String emptyMessage;
    String emptySubtitle;

    if (taskProvider.isShowingAll) {
      emptyMessage = 'No hay tareas creadas';
      emptySubtitle = 'Crea tu primera tarea o usa las opciones de debug';
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
            const SizedBox(height: 32),
            // Botones de debug
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => taskProvider.debugTasksState(),
                  icon: const Icon(Icons.info, size: 18),
                  label: const Text('Debug Info'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.dark,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await taskProvider.createTestTasks();
                  },
                  icon: const Icon(Icons.science, size: 18),
                  label: const Text('Crear Pruebas'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: AppColors.light,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await taskProvider.reloadTasks();
                  },
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Recargar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.warning,
                    foregroundColor: AppColors.dark,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Total en memoria: ${taskProvider.allTasks.length} tareas',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.darkGrey.withValues(alpha: 0.5),
              ),
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
                onPressed: () async {
                  await taskProvider.clearAllTasks();
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Todas las tareas han sido eliminadas'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                },
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
                child: const Text('Eliminar Todo'),
              ),
            ],
          ),
    );
  }
}
