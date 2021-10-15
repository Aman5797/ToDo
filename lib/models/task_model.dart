final String tableTasks = 'tasks';

class TaskFields {
  static final List<String> values = [
    /// Add all fields
    id, description
  ];
  static final String id = '_id';
  static final String description = 'description';
}

class TaskModel {
  final int? id;
  final String description;

  const TaskModel({
    this.id,
    required this.description,
  });

  TaskModel copy({
    int? id,
    String? description,
  }) =>
      TaskModel(
        id: id ?? this.id,
        description: description ?? this.description,
      );

  static TaskModel fromMap(Map<String, Object?> map) => TaskModel(
        id: map[TaskFields.id] as int?,
        description: map[TaskFields.description] as String,
      );

  Map<String, Object?> toMap() => {
        TaskFields.id: id,
        TaskFields.description: description,
      };
}
