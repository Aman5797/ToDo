import 'package:task_manager/database/database_helper.dart';
import 'package:task_manager/models/task_model.dart';

class TaskDatabase extends DatabaseHelper {
  static final TaskDatabase instance = TaskDatabase._init();
  TaskDatabase._init();
  factory TaskDatabase() => instance;

  // ---------------------------Tasks--------------------

  Future<TaskModel> createTask(TaskModel taskModel) async {
    print('In create Task');
    final db = await instance.database;

    final id = await db.insert(tableTasks, taskModel.toMap());
    print('Insert ID : $id');
    return taskModel.copy(id: id);
  }

  Future<TaskModel> readTask(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableTasks,
      columns: TaskFields.values,
      where: '${TaskFields.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return TaskModel.fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<TaskModel>> readAllTasks() async {
    final db = await instance.database;

    final result = await db.query(tableTasks);

    return result.map((val) => TaskModel.fromMap(val)).toList();
  }

  Future<int> deleteTask(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableTasks,
      where: '${TaskFields.id} = ?',
      whereArgs: [id],
    );
  }
}
