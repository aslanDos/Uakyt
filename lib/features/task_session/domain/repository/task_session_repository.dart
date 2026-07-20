import 'package:dartz/dartz.dart';
import 'package:uakyt/core/errors/failure.dart';
import 'package:uakyt/features/task_session/domain/entity/task_session_entity.dart';

abstract class TaskSessionRepository {
  Future<Either<Failure, TaskSessionEntity>> startSession(String taskId);
  Future<Either<Failure, TaskSessionEntity?>> getCurrentSession();
  Future<Either<Failure, List<TaskSessionEntity>>> getCompletedSessions();
  Future<Either<Failure, TaskSessionEntity>> finishCurrentSession();
}
