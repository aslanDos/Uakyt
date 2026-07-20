import 'package:dartz/dartz.dart';
import 'package:uakyt/core/errors/failure.dart';
import 'package:uakyt/features/task_session/data/data_source/task_session_local_data_source.dart';
import 'package:uakyt/features/task_session/data/model/task_session_model.dart';
import 'package:uakyt/features/task_session/domain/entity/task_session_entity.dart';
import 'package:uakyt/features/task_session/domain/repository/task_session_repository.dart';

class TaskSessionRepositoryImpl implements TaskSessionRepository {
  const TaskSessionRepositoryImpl({
    required TaskSessionLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource;

  final TaskSessionLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, TaskSessionEntity>> startSession(String taskId) async {
    try {
      final now = DateTime.now();
      final session = TaskSessionModel(
        id: now.microsecondsSinceEpoch.toString(),
        taskId: taskId,
        startedAt: now,
      );

      return Right(await _localDataSource.startSession(session));
    } catch (error) {
      return Left(DatabaseFailure('Failed to start task session: $error'));
    }
  }

  @override
  Future<Either<Failure, TaskSessionEntity?>> getCurrentSession() async {
    try {
      return Right(await _localDataSource.getCurrentSession());
    } catch (error) {
      return Left(
        DatabaseFailure('Failed to get current task session: $error'),
      );
    }
  }

  @override
  Future<Either<Failure, List<TaskSessionEntity>>>
  getCompletedSessions() async {
    try {
      return Right(await _localDataSource.getCompletedSessions());
    } catch (error) {
      return Left(
        DatabaseFailure('Failed to get completed task sessions: $error'),
      );
    }
  }

  @override
  Future<Either<Failure, TaskSessionEntity>> finishCurrentSession() async {
    try {
      return Right(await _localDataSource.finishCurrentSession(DateTime.now()));
    } catch (error) {
      return Left(DatabaseFailure('Failed to finish task session: $error'));
    }
  }
}
