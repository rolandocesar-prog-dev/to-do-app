import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class StorageService {
  static const String _tasksKey = 'tasks';

  Future<List<Task>> loadTasks() async {
    try {
      print('=== LOADING TASKS FROM STORAGE ===');
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = prefs.getString(_tasksKey);

      if (tasksJson == null || tasksJson.isEmpty) {
        print('No tasks found in storage');
        return [];
      }

      print('Raw JSON from storage: $tasksJson');

      final List<dynamic> tasksList = jsonDecode(tasksJson);
      print('Decoded ${tasksList.length} tasks from JSON');

      final List<Task> tasks = [];

      for (int i = 0; i < tasksList.length; i++) {
        try {
          final task = Task.fromJson(tasksList[i]);
          tasks.add(task);
          print('Loaded task $i: ${task.title} - ${task.status}');
        } catch (e) {
          print('Error loading task $i: $e');
          print('Task data: ${tasksList[i]}');
        }
      }

      print('Successfully loaded ${tasks.length} tasks');
      print('Task statuses:');
      for (var status in TaskStatus.values) {
        final count = tasks.where((t) => t.status == status).length;
        print('  ${status.name}: $count');
      }
      print('=================================');

      return tasks;
    } catch (e) {
      print('Error loading tasks: $e');
      return [];
    }
  }

  Future<void> saveTasks(List<Task> tasks) async {
    try {
      print('=== SAVING TASKS TO STORAGE ===');
      print('Saving ${tasks.length} tasks');

      final prefs = await SharedPreferences.getInstance();

      // Convert tasks to JSON
      final List<Map<String, dynamic>> tasksJson = [];
      for (int i = 0; i < tasks.length; i++) {
        try {
          final taskJson = tasks[i].toJson();
          tasksJson.add(taskJson);
          print(
            'Task $i: ${tasks[i].title} - ${tasks[i].status} -> ${taskJson['status']}',
          );
        } catch (e) {
          print('Error converting task $i to JSON: $e');
        }
      }

      final jsonString = jsonEncode(tasksJson);
      await prefs.setString(_tasksKey, jsonString);

      print('Tasks saved successfully');
      print('JSON saved: ${jsonString.substring(0, 100)}...');
      print('===============================');
    } catch (e) {
      print('Error saving tasks: $e');
    }
  }

  // Método para limpiar el storage (útil para debug)
  Future<void> clearStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tasksKey);
      print('Storage cleared successfully');
    } catch (e) {
      print('Error clearing storage: $e');
    }
  }

  // Método para debug - ver contenido raw del storage
  Future<void> debugStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = prefs.getString(_tasksKey);
      print('=== STORAGE DEBUG ===');
      print('Raw storage content:');
      print(tasksJson ?? 'NULL');
      print('====================');
    } catch (e) {
      print('Error debugging storage: $e');
    }
  }
}
