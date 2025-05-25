import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/storage_service.dart';

class TaskProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();

  List<Task> _tasks = [];
  TaskStatus? _filterStatus; // null = mostrar todas las tareas
  bool _isLoading = false;

  // Getter para tareas filtradas
  List<Task> get tasks {
    if (_filterStatus == null) {
      // Mostrar TODAS las tareas (pendientes, completas, canceladas)
      return List<Task>.from(_tasks);
    } else {
      // Filtrar por estado específico
      final filteredTasks =
          _tasks.where((task) => task.status == _filterStatus).toList();
      return filteredTasks;
    }
  }

  List<Task> get allTasks => _tasks;
  TaskStatus? get filterStatus => _filterStatus;
  bool get isLoading => _isLoading;
  bool get isShowingAll => _filterStatus == null;

  // Contadores por estado
  int get pendingCount =>
      _tasks.where((t) => t.status == TaskStatus.pending).length;
  int get completedCount =>
      _tasks.where((t) => t.status == TaskStatus.completed).length;
  int get cancelledCount =>
      _tasks.where((t) => t.status == TaskStatus.cancelled).length;

  TaskProvider() {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _tasks = await _storageService.loadTasks();
      print('TaskProvider: Loaded ${_tasks.length} tasks');
      debugTasksState();
    } catch (e) {
      print('TaskProvider: Error loading tasks: $e');
      _tasks = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(String title, String description) async {
    final task = Task(title: title, description: description);
    _tasks.insert(0, task);
    await _saveTasks();
    print('TaskProvider: Added task: ${task.title}');
    notifyListeners();
  }

  Future<void> updateTaskStatus(String taskId, TaskStatus newStatus) async {
    print('=== TaskProvider: UPDATING TASK STATUS ===');
    print('Task ID: $taskId');
    print('New Status: $newStatus');

    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);

    if (taskIndex == -1) {
      print('ERROR: Task not found with ID: $taskId');
      return;
    }

    final oldTask = _tasks[taskIndex];
    print('Old task: ${oldTask.title} - Status: ${oldTask.status}');

    DateTime? completedAt;
    if (newStatus == TaskStatus.completed) {
      completedAt = DateTime.now();
    } else {
      completedAt = null;
    }

    // Crear nueva tarea con el estado actualizado
    final updatedTask = oldTask.copyWith(
      status: newStatus,
      completedAt: completedAt,
    );

    // Reemplazar la tarea en la lista
    _tasks[taskIndex] = updatedTask;

    print('Updated task: ${updatedTask.title} - Status: ${updatedTask.status}');

    // Guardar cambios INMEDIATAMENTE
    await _saveTasks();

    // Verificar contadores después de la actualización
    print('Task counts after update:');
    print('- Pending: $pendingCount');
    print('- Completed: $completedCount');
    print('- Cancelled: $cancelledCount');

    // Verificar que la tarea está en la lista con el estado correcto
    final verifyTask = _tasks.firstWhere((t) => t.id == taskId);
    print('Verification - Task status in list: ${verifyTask.status}');
    print('=========================================');

    // Notificar cambios
    notifyListeners();
  }

  Future<void> deleteTask(String taskId) async {
    final taskToDelete = _tasks.firstWhere((task) => task.id == taskId);
    _tasks.removeWhere((task) => task.id == taskId);
    await _saveTasks();
    print('TaskProvider: Deleted task: ${taskToDelete.title}');
    notifyListeners();
  }

  // Método privado para guardar tareas
  Future<void> _saveTasks() async {
    try {
      await _storageService.saveTasks(_tasks);
      print('TaskProvider: Tasks saved successfully. Total: ${_tasks.length}');
    } catch (e) {
      print('TaskProvider: Error saving tasks: $e');
    }
  }

  // Establecer filtro específico
  void setFilter(TaskStatus status) {
    _filterStatus = status;
    print('TaskProvider: Filter set to: $status');
    final filteredCount = tasks.length; // Esto ejecuta el getter
    print('TaskProvider: Filtered tasks count: $filteredCount');
    notifyListeners();
  }

  // Mostrar todas las tareas
  void showAllTasks() {
    _filterStatus = null;
    print('TaskProvider: Showing all tasks');
    print('TaskProvider: Total tasks: ${_tasks.length}');
    notifyListeners();
  }

  // Método para debug del estado actual
  void debugTasksState() {
    print('=== TASKPROVIDER DEBUG STATE ===');
    print('Total tasks: ${_tasks.length}');
    print('Current filter: $_filterStatus');
    print('Pending: $pendingCount');
    print('Completed: $completedCount');
    print('Cancelled: $cancelledCount');
    print('Tasks in memory:');

    for (int i = 0; i < _tasks.length; i++) {
      final task = _tasks[i];
      print(
        '  [$i] ${task.title} - ${task.status} - ID: ${task.id.substring(0, 8)}...',
      );
    }

    print('Filtered tasks (current view): ${tasks.length}');
    print('===============================');

    // También debug del storage
    _storageService.debugStorage();
  }

  // Método para limpiar todas las tareas
  Future<void> clearAllTasks() async {
    _tasks.clear();
    await _saveTasks();
    await _storageService.clearStorage(); // Limpiar storage también
    print('TaskProvider: All tasks cleared');
    notifyListeners();
  }

  // Método para crear tareas de prueba con TODOS los estados
  Future<void> createTestTasks() async {
    await clearAllTasks();

    print('=== CREATING TEST TASKS ===');

    // Crear 3 tareas diferentes
    final task1 = Task(
      title: 'Tarea Pendiente Test',
      description: 'Esta tarea está pendiente',
    );
    final task2 = Task(
      title: 'Tarea para Completar',
      description: 'Esta tarea será completada',
    );
    final task3 = Task(
      title: 'Tarea para Cancelar',
      description: 'Esta tarea será cancelada',
    );

    _tasks.addAll([task1, task2, task3]);
    await _saveTasks();

    print('Created 3 base tasks');

    // Marcar la segunda como completada
    await updateTaskStatus(task2.id, TaskStatus.completed);
    print('Marked task2 as completed');

    // Marcar la tercera como cancelada
    await updateTaskStatus(task3.id, TaskStatus.cancelled);
    print('Marked task3 as cancelled');

    print('=== TEST TASKS CREATED ===');
    print('Should have: 1 pending, 1 completed, 1 cancelled');
    debugTasksState();
    print('=========================');
  }

  // Método para recargar tareas desde storage (útil para debug)
  Future<void> reloadTasks() async {
    print('TaskProvider: Reloading tasks from storage...');
    await _loadTasks();
  }
}
