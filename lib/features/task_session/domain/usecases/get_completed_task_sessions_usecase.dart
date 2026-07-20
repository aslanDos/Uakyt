import 'package:dartz/dartz.dart';
import 'package:uakyt/core/errors/failure.dart';
import 'package:uakyt/core/utils/usecase.dart';
import 'package:uakyt/features/task_session/domain/entity/task_session_entity.dart';
import 'package:uakyt/features/task_session/domain/repository/task_session_repository.dart';

class GetCompletedTaskSessionsUsecase
    extends UseCase<List<TaskSessionEntity>, NoParams> {
  GetCompletedTaskSessionsUsecase({required TaskSessionRepository repository})
    : _repository = repository;

  final TaskSessionRepository _repository;

  @override
  Future<Either<Failure, List<TaskSessionEntity>>> call(NoParams params) {
    return _repository.getCompletedSessions();
  }
}
