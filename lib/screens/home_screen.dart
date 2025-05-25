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
                          taskProvider.isShowingAll
                              ? 'No hay tareas'
                              : 'No hay tareas en esta categoría',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.darkGrey.withOpacity(0.7),
                          ),
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
}
