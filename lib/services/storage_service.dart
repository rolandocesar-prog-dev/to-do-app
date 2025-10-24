import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class StorageService {
  static const String _tasksKey = 'tasks';
  
  // Cache de SharedPreferences para evitar múltiples instancias
  SharedPreferences? _prefs;
  
  Future<SharedPreferences> get _preferences async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<List<Task>> loadTasks() async {
    try {
      final prefs = await _preferences;
      final tasksJson = prefs.getString(_tasksKey);

      if (tasksJson == null || tasksJson.isEmpty) {
        return [];
      }

      final List<dynamic> tasksList = jsonDecode(tasksJson);
      final List<Task> tasks = [];

      for (final taskData in tasksList) {
        try {
          final task = Task.fromJson(taskData);
          tasks.add(task);
        } catch (e) {
          // En producción, podrías registrar esto en un servicio de analytics
          continue;
        }
      }

      return tasks;
    } catch (e) {
      return [];
    }
  }

  Future<void> saveTasks(List<Task> tasks) async {
    try {
      final prefs = await _preferences;
      
      // Optimización: usar map directamente
      final tasksJson = tasks.map((task) => task.toJson()).toList();
      final jsonString = jsonEncode(tasksJson);
      
      await prefs.setString(_tasksKey, jsonString);
    } catch (e) {
      // En producción, manejar el error apropiadamente
      rethrow;
    }
  }
}
