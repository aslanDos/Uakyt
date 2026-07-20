import 'package:dartz/dartz.dart';
import 'package:uakyt/core/errors/failure.dart';
import 'package:uakyt/features/task/data/data_source/task_local_data_source.dart';
import 'package:uakyt/features/task/data/model/task_model.dart';
import 'package:uakyt/features/task/domain/entity/task_entity.dart';
import 'package:uakyt/features/task/domain/repository/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  const TaskRepositoryImpl({required TaskLocalDataSource localDataSource})
    : _localDataSource = localDataSource;

  final TaskLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, TaskEntity>> createTask(TaskEntity task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      final createdTask = await _localDataSource.createTask(taskModel);

      return Right(createdTask);
    } catch (error) {
      return Left(DatabaseFailure('Failed to create task: $error'));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> updateTask(TaskEntity task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      final updatedTask = await _localDataSource.updateTask(taskModel);

      return Right(updatedTask);
    } catch (error) {
      return Left(DatabaseFailure('Failed to update task: $error'));
    }
  }

  @override
  Future<Either<Failure, TaskEntity>> getTaskById(String id) async {
    try {
      final task = await _localDataSource.getTaskById(id);

      if (task == null) {
        return Left(NotFoundFailure('Task with id "$id" was not found.'));
      }

      return Right(task);
    } catch (error) {
      return Left(DatabaseFailure('Failed to get task: $error'));
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasks() async {
    try {
      final tasks = await _localDataSource.getTasks();

      return Right(tasks);
    } catch (error) {
      return Left(DatabaseFailure('Failed to get tasks: $error'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String id) async {
    try {
      await _localDataSource.deleteTask(id);

      return const Right(null);
    } catch (error) {
      return Left(DatabaseFailure('Failed to delete task: $error'));
    }
  }
}
