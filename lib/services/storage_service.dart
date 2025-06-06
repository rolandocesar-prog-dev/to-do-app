import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class StorageService {
  static const String _tasksKey = 'tasks';

  Future<List<Task>> loadTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = prefs.getString(_tasksKey);

      if (tasksJson == null || tasksJson.isEmpty) {
        return [];
      }

      final List<dynamic> tasksList = jsonDecode(tasksJson);
      final List<Task> tasks = [];

      for (int i = 0; i < tasksList.length; i++) {
        try {
          final task = Task.fromJson(tasksList[i]);
          tasks.add(task);
        } catch (e) {
          // En producción, podrías registrar esto en un servicio de analytics
          // pero no en la consola
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
      final prefs = await SharedPreferences.getInstance();

      // Convert tasks to JSON
      final List<Map<String, dynamic>> tasksJson = [];
      for (int i = 0; i < tasks.length; i++) {
        try {
          final taskJson = tasks[i].toJson();
          tasksJson.add(taskJson);
        } catch (e) {
          // En producción, podrías registrar esto en un servicio de analytics
          continue;
        }
      }

      final jsonString = jsonEncode(tasksJson);
      await prefs.setString(_tasksKey, jsonString);
    } catch (e) {
      // En producción, manejar el error apropiadamente
      rethrow;
    }
  }
}
