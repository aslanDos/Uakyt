import 'package:dartz/dartz.dart';
import 'package:uakyt/core/errors/failure.dart';
import 'package:uakyt/core/utils/usecase.dart';
import 'package:uakyt/features/task/domain/entity/task_entity.dart';
import 'package:uakyt/features/task/domain/repository/task_repository.dart';

class GetTasksUsecase extends UseCase<List<TaskEntity>, NoParams> {
  final TaskRepository repository;
  GetTasksUsecase({required this.repository});

  @override
  Future<Either<Failure, List<TaskEntity>>> call(NoParams params) {
    return repository.getTasks();
  }
}
