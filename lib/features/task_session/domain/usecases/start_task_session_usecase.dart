import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:uakyt/core/errors/failure.dart';
import 'package:uakyt/core/utils/usecase.dart';
import 'package:uakyt/features/task_session/domain/entity/task_session_entity.dart';
import 'package:uakyt/features/task_session/domain/repository/task_session_repository.dart';

class StartTaskSessionUsecase
    extends UseCase<TaskSessionEntity, StartTaskSessionUsecaseParams> {
  StartTaskSessionUsecase({required TaskSessionRepository repository})
    : _repository = repository;

  final TaskSessionRepository _repository;

  @override
  Future<Either<Failure, TaskSessionEntity>> call(
    StartTaskSessionUsecaseParams params,
  ) {
    return _repository.startSession(params.taskId);
  }
}

class StartTaskSessionUsecaseParams extends Equatable {
  const StartTaskSessionUsecaseParams({required this.taskId});

  final String taskId;

  @override
  List<Object?> get props => [taskId];
}
