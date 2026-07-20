import 'package:uakyt/features/task/data/model/task_model.dart';

abstract class TaskLocalDataSource {
  Future<TaskModel> createTask(TaskModel task);
  Future<TaskModel> updateTask(TaskModel task);
  Future<TaskModel?> getTaskById(String id);
  Future<List<TaskModel>> getTasks();
  Future<void> deleteTask(String id);
}
