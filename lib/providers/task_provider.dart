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
    } catch (e) {
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

  Future<void> updateTaskStatus(String taskId, TaskStatus newStatus) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);

    if (taskIndex == -1) {
      return;
    }

    final oldTask = _tasks[taskIndex];

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

    // Guardar cambios
    await _saveTasks();

    // Notificar cambios
    notifyListeners();
  }

  Future<void> deleteTask(String taskId) async {
    _tasks.removeWhere((task) => task.id == taskId);
    await _saveTasks();
    notifyListeners();
  }

  // Método privado para guardar tareas
  Future<void> _saveTasks() async {
    try {
      await _storageService.saveTasks(_tasks);
    } catch (e) {
      // En producción, aquí podrías manejar el error de otra forma
      // como mostrar un mensaje al usuario
    }
  }

  // Establecer filtro específico
  void setFilter(TaskStatus status) {
    _filterStatus = status;
    notifyListeners();
  }

  // Mostrar todas las tareas
  void showAllTasks() {
    _filterStatus = null;
    notifyListeners();
  }
}
