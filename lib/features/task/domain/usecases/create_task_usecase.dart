// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:uakyt/core/errors/failure.dart';

import 'package:uakyt/core/utils/usecase.dart';
import 'package:uakyt/features/task/domain/entity/task_entity.dart';
import 'package:uakyt/features/task/domain/repository/task_repository.dart';

class CreateTaskUsecase extends UseCase<TaskEntity, CreateTaskUsecaseParams> {
  final TaskRepository repository;
  CreateTaskUsecase({required this.repository});

  @override
  Future<Either<Failure, TaskEntity>> call(CreateTaskUsecaseParams params) {
    return repository.createTask(params.task);
  }
}

class CreateTaskUsecaseParams extends Equatable {
  final TaskEntity task;
  const CreateTaskUsecaseParams({required this.task});

  @override
  List<Object?> get props => [task];
}
