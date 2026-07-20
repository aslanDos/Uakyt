import 'package:drift/drift.dart';
import 'package:uakyt/core/database/app_database.dart';
import 'package:uakyt/features/task/data/data_source/task_local_data_source.dart';
import 'package:uakyt/features/task/data/model/task_model.dart';

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  const TaskLocalDataSourceImpl({required AppDatabase database})
    : _database = database;

  final AppDatabase _database;

  @override
  Future<TaskModel> createTask(TaskModel task) async {
    await _database.into(_database.tasks).insert(task.toCompanion());
    return task;
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    await _database.update(_database.tasks).replace(task.toCompanion());
    return task;
  }

  @override
  Future<TaskModel?> getTaskById(String id) async {
    final row = await (_database.select(
      _database.tasks,
    )..where((table) => table.id.equals(id))).getSingleOrNull();

    if (row == null) {
      return null;
    }

    return TaskModel.fromDrift(row);
  }

  @override
  Future<List<TaskModel>> getTasks() async {
    final rows =
        await (_database.select(_database.tasks)
              ..where((table) => table.isArchived.equals(false))
              ..orderBy([
                (table) => OrderingTerm(
                  expression: table.createdAt,
                  mode: OrderingMode.desc,
                ),
              ]))
            .get();

    return rows.map(TaskModel.fromDrift).toList();
  }

  @override
  Future<void> deleteTask(String id) async {
    await (_database.delete(
      _database.tasks,
    )..where((table) => table.id.equals(id))).go();
  }
}
