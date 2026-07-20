import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uakyt/core/database/app_database.dart';
import 'package:uakyt/core/utils/usecase.dart';
import 'package:uakyt/features/task/data/data_source/task_local_data_source.dart';
import 'package:uakyt/features/task/data/data_source/task_local_data_source_impl.dart';
import 'package:uakyt/features/task/data/repository/task_repository_impl.dart';
import 'package:uakyt/features/task/domain/entity/task_entity.dart';
import 'package:uakyt/features/task/domain/repository/task_repository.dart';
import 'package:uakyt/features/task/domain/usecases/create_task_usecase.dart';
import 'package:uakyt/features/task/domain/usecases/get_tasks_usecase.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();

  ref.onDispose(database.close);

  return database;
});

final taskLocalDataSourceProvider = Provider<TaskLocalDataSource>((ref) {
  return TaskLocalDataSourceImpl(database: ref.watch(appDatabaseProvider));
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepositoryImpl(
    localDataSource: ref.watch(taskLocalDataSourceProvider),
  );
});

final createTaskUsecaseProvider = Provider<CreateTaskUsecase>((ref) {
  return CreateTaskUsecase(repository: ref.watch(taskRepositoryProvider));
});

final getTasksUsecaseProvider = Provider<GetTasksUsecase>((ref) {
  return GetTasksUsecase(repository: ref.watch(taskRepositoryProvider));
});

final tasksProvider = AsyncNotifierProvider<TasksNotifier, List<TaskEntity>>(
  TasksNotifier.new,
);

class TasksNotifier extends AsyncNotifier<List<TaskEntity>> {
  @override
  Future<List<TaskEntity>> build() {
    return _loadTasks();
  }

  Future<void> createTask(TaskEntity task) async {
    state = const AsyncLoading();

    final result = await ref.read(createTaskUsecaseProvider)(
      CreateTaskUsecaseParams(task: task),
    );

    await result.fold(
      (failure) async {
        state = AsyncError(failure, StackTrace.current);
      },
      (_) async {
        state = AsyncData(await _loadTasks());
      },
    );
  }

  Future<List<TaskEntity>> _loadTasks() async {
    final result = await ref.read(getTasksUsecaseProvider)(const NoParams());

    return result.fold((failure) => throw failure, (tasks) => tasks);
  }
}
