import 'package:dartz/dartz.dart';
import 'package:uakyt/core/errors/failure.dart';
import 'package:uakyt/features/task/domain/entity/task_entity.dart';

abstract class TaskRepository {
  Future<Either<Failure, TaskEntity>> createTask(TaskEntity task);
  Future<Either<Failure, TaskEntity>> updateTask(TaskEntity task);
  Future<Either<Failure, TaskEntity>> getTaskById(String id);
  Future<Either<Failure, List<TaskEntity>>> getTasks();
  Future<Either<Failure, void>> deleteTask(String id);
}
