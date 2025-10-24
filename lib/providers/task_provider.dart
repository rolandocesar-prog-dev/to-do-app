import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/storage_service.dart';

class TaskProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();

  List<Task> _tasks = [];
  TaskStatus? _filterStatus; // null = mostrar todas las tareas
  bool _isLoading = false;
  
  // Cache para contadores
  int? _cachedPendingCount;
  int? _cachedCompletedCount;
  int? _cachedCancelledCount;
  
  // Cache para tareas filtradas
  Map<TaskStatus?, List<Task>> _filteredTasksCache = {};

  // Getter para tareas filtradas con cache
  List<Task> get tasks {
    if (_filteredTasksCache.containsKey(_filterStatus)) {
      return _filteredTasksCache[_filterStatus]!;
    }
    
    final filtered = _filterStatus == null 
        ? List<Task>.from(_tasks)
        : _tasks.where((task) => task.status == _filterStatus).toList();
    
    _filteredTasksCache[_filterStatus] = filtered;
    return filtered;
  }

  List<Task> get allTasks => _tasks;
  TaskStatus? get filterStatus => _filterStatus;
  bool get isLoading => _isLoading;
  bool get isShowingAll => _filterStatus == null;

  // Contadores optimizados con cache
  int get pendingCount {
    if (_cachedPendingCount == null) {
      _cachedPendingCount = _tasks.where((t) => t.status == TaskStatus.pending).length;
    }
    return _cachedPendingCount!;
  }
  
  int get completedCount {
    if (_cachedCompletedCount == null) {
      _cachedCompletedCount = _tasks.where((t) => t.status == TaskStatus.completed).length;
    }
    return _cachedCompletedCount!;
  }
  
  int get cancelledCount {
    if (_cachedCancelledCount == null) {
      _cachedCancelledCount = _tasks.where((t) => t.status == TaskStatus.cancelled).length;
    }
    return _cachedCancelledCount!;
  }

  TaskProvider() {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _tasks = await _storageService.loadTasks();
      _invalidateCache();
    } catch (e) {
      _tasks = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(String title, String description) async {
    final task = Task(title: title, description: description);
    _tasks.insert(0, task);
    _invalidateCache();
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
    _invalidateCache();

    // Guardar cambios
    await _saveTasks();

    // Notificar cambios
    notifyListeners();
  }

  Future<void> deleteTask(String taskId) async {
    _tasks.removeWhere((task) => task.id == taskId);
    _invalidateCache();
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
  
  // Invalidar cache cuando sea necesario
  void _invalidateCache() {
    _cachedPendingCount = null;
    _cachedCompletedCount = null;
    _cachedCancelledCount = null;
    _filteredTasksCache.clear();
  }
}
