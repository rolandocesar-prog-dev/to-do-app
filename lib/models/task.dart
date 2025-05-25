import 'package:uuid/uuid.dart';

enum TaskStatus { pending, completed, cancelled }

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
      'status': status.index,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      completedAt:
          json['completedAt'] != null
              ? DateTime.parse(json['completedAt'])
              : null,
      status: TaskStatus.values[json['status']],
    );
  }
}
