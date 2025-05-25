import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/storage_service.dart';

class TaskProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();

  List<Task> _tasks = [];
  TaskStatus? _filterStatus; // null = mostrar todas las tareas
  bool _isLoading = false;

  // Getter para tareas filtradas con debug mejorado
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
      debugTasksState();
    } catch (e) {
      print('Error loading tasks: $e');
      _tasks = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(String title, String description) async {
    final task = Task(title: title, description: description);
    _tasks.insert(0, task);
    await _saveTasks();
    notifyListeners();
  }

  // Método updateTaskStatus con debug extensivo
  Future<void> updateTaskStatus(String taskId, TaskStatus newStatus) async {
    print('=== UPDATING TASK STATUS ===');
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

    // Guardar cambios
    await _saveTasks();

    // Verificar que se guardó correctamente
    print('Task counts after update:');
    print('- Pending: $pendingCount');
    print('- Completed: $completedCount');
    print('- Cancelled: $cancelledCount');
    print('========================');

    // Notificar cambios
    notifyListeners();
  }

  Future<void> deleteTask(String taskId) async {
    final taskToDelete = _tasks.firstWhere((task) => task.id == taskId);
    _tasks.removeWhere((task) => task.id == taskId);
    await _saveTasks();
    print('Deleted task: ${taskToDelete.title}');
    notifyListeners();
  }

  // Método privado para guardar tareas
  Future<void> _saveTasks() async {
    try {
      await _storageService.saveTasks(_tasks);
      print('Tasks saved successfully. Total: ${_tasks.length}');
    } catch (e) {
      print('Error saving tasks: $e');
    }
  }

  // Establecer filtro específico
  void setFilter(TaskStatus status) {
    _filterStatus = status;
    print('Filter set to: $status');
    notifyListeners();
  }

  // Mostrar todas las tareas
  void showAllTasks() {
    _filterStatus = null;
    print('Showing all tasks');
    notifyListeners();
  }

  // Método para debug del estado actual
  void debugTasksState() {
    print('=== CURRENT STATE DEBUG ===');
    print('Total tasks: ${_tasks.length}');
    print('Current filter: $_filterStatus');
    print('Pending: $pendingCount');
    print('Completed: $completedCount');
    print('Cancelled: $cancelledCount');
    print('Tasks list:');

    for (int i = 0; i < _tasks.length; i++) {
      final task = _tasks[i];
      print(
        '  [$i] ${task.title} - ${task.status} - ID: ${task.id.substring(0, 8)}...',
      );
    }
    print('==========================');
  }

  // Método para limpiar todas las tareas (útil para testing)
  Future<void> clearAllTasks() async {
    _tasks.clear();
    await _saveTasks();
    print('All tasks cleared');
    notifyListeners();
  }

  // Método para crear tareas de prueba
  Future<void> createTestTasks() async {
    await clearAllTasks();

    // Crear tareas de prueba
    final testTasks = [
      Task(title: 'Tarea Pendiente 1', description: 'Descripción pendiente'),
      Task(title: 'Tarea Pendiente 2', description: 'Otra tarea pendiente'),
    ];

    _tasks.addAll(testTasks);
    await _saveTasks();

    // Marcar una como completada y otra como cancelada
    await updateTaskStatus(_tasks[0].id, TaskStatus.completed);
    await updateTaskStatus(_tasks[1].id, TaskStatus.cancelled);

    print('Test tasks created');
  }
}
