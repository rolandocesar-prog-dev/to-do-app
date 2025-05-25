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
      return _tasks;
    } else {
      // Filtrar por estado específico
      return _tasks.where((task) => task.status == _filterStatus).toList();
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

    _tasks = await _storageService.loadTasks();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(String title, String description) async {
    final task = Task(title: title, description: description);
    _tasks.insert(0, task);
    await _storageService.saveTasks(_tasks);
    notifyListeners();
  }

  Future<void> updateTaskStatus(String taskId, TaskStatus status) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1) {
      _tasks[taskIndex] = _tasks[taskIndex].copyWith(
        status: status,
        completedAt: status == TaskStatus.completed ? DateTime.now() : null,
      );
      await _storageService.saveTasks(_tasks);
      notifyListeners();
    }
  }

  Future<void> deleteTask(String taskId) async {
    _tasks.removeWhere((task) => task.id == taskId);
    await _storageService.saveTasks(_tasks);
    notifyListeners();
  }

  // Establecer filtro específico (pendientes, completadas, canceladas)
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
