import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class StorageService {
  static const String _tasksKey = 'tasks';

  Future<List<Task>> loadTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = prefs.getString(_tasksKey);

      if (tasksJson == null) return [];

      final List<dynamic> tasksList = jsonDecode(tasksJson);
      return tasksList.map((json) => Task.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveTasks(List<Task> tasks) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = jsonEncode(tasks.map((task) => task.toJson()).toList());
      await prefs.setString(_tasksKey, tasksJson);
    } catch (e) {
      // Handle error
    }
  }
}
