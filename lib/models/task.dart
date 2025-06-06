import 'package:uuid/uuid.dart';

enum TaskStatus { pending, completed, cancelled }

extension TaskStatusExtension on TaskStatus {
  String get name {
    switch (this) {
      case TaskStatus.pending:
        return 'pending';
      case TaskStatus.completed:
        return 'completed';
      case TaskStatus.cancelled:
        return 'cancelled';
    }
  }

  static TaskStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return TaskStatus.pending;
      case 'completed':
        return TaskStatus.completed;
      case 'cancelled':
        return TaskStatus.cancelled;
      default:
        return TaskStatus.pending; // Default fallback
    }
  }
}

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime? completedAt;
  final TaskStatus status;

  Task({
    String? id,
    required this.title,
    this.description = '',
    DateTime? createdAt,
    this.completedAt,
    this.status = TaskStatus.pending,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  Task copyWith({
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? completedAt,
    TaskStatus? status,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'status': status.name,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    try {
      return Task(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        createdAt:
            json['createdAt'] != null
                ? DateTime.parse(json['createdAt'])
                : DateTime.now(),
        completedAt:
            json['completedAt'] != null
                ? DateTime.parse(json['completedAt'])
                : null,
        status:
            json['status'] != null
                ? TaskStatusExtension.fromString(json['status'].toString())
                : TaskStatus.pending,
      );
    } catch (e) {
      // Return a default task in case of error
      return Task(
        title: json['title']?.toString() ?? 'Tarea sin título',
        description: json['description']?.toString() ?? '',
        status: TaskStatus.pending,
      );
    }
  }

  @override
  String toString() {
    return 'Task{id: ${id.substring(0, 8)}, title: $title, status: $status}';
  }
}
