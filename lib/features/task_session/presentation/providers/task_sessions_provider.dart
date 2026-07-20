import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uakyt/core/utils/usecase.dart';
import 'package:uakyt/features/task/presentation/providers/tasks_provider.dart';
import 'package:uakyt/features/task_session/data/data_source/task_session_local_data_source.dart';
import 'package:uakyt/features/task_session/data/data_source/task_session_local_data_source_impl.dart';
import 'package:uakyt/features/task_session/data/repository/task_session_repository_impl.dart';
import 'package:uakyt/features/task_session/domain/entity/task_session_entity.dart';
import 'package:uakyt/features/task_session/domain/repository/task_session_repository.dart';
import 'package:uakyt/features/task_session/domain/usecases/finish_current_task_session_usecase.dart';
import 'package:uakyt/features/task_session/domain/usecases/get_completed_task_sessions_usecase.dart';
import 'package:uakyt/features/task_session/domain/usecases/get_current_task_session_usecase.dart';
import 'package:uakyt/features/task_session/domain/usecases/start_task_session_usecase.dart';

final taskSessionLocalDataSourceProvider = Provider<TaskSessionLocalDataSource>(
  (ref) {
    return TaskSessionLocalDataSourceImpl(
      database: ref.watch(appDatabaseProvider),
    );
  },
);

final taskSessionRepositoryProvider = Provider<TaskSessionRepository>((ref) {
  return TaskSessionRepositoryImpl(
    localDataSource: ref.watch(taskSessionLocalDataSourceProvider),
  );
});

final startTaskSessionUsecaseProvider = Provider<StartTaskSessionUsecase>((
  ref,
) {
  return StartTaskSessionUsecase(
    repository: ref.watch(taskSessionRepositoryProvider),
  );
});

final finishCurrentTaskSessionUsecaseProvider =
    Provider<FinishCurrentTaskSessionUsecase>((ref) {
      return FinishCurrentTaskSessionUsecase(
        repository: ref.watch(taskSessionRepositoryProvider),
      );
    });

final getCurrentTaskSessionUsecaseProvider =
    Provider<GetCurrentTaskSessionUsecase>((ref) {
      return GetCurrentTaskSessionUsecase(
        repository: ref.watch(taskSessionRepositoryProvider),
      );
    });

final getCompletedTaskSessionsUsecaseProvider =
    Provider<GetCompletedTaskSessionsUsecase>((ref) {
      return GetCompletedTaskSessionsUsecase(
        repository: ref.watch(taskSessionRepositoryProvider),
      );
    });

final taskSessionsProvider =
    AsyncNotifierProvider<TaskSessionsNotifier, TaskSessionsState>(
      TaskSessionsNotifier.new,
    );

final currentTimeProvider = StreamProvider<DateTime>((ref) async* {
  yield DateTime.now();
  yield* Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
});

class TaskSessionsState extends Equatable {
  const TaskSessionsState({
    required this.completedSessions,
    this.currentSession,
  });

  final TaskSessionEntity? currentSession;
  final List<TaskSessionEntity> completedSessions;

  @override
  List<Object?> get props => [currentSession, completedSessions];
}

class TaskSessionsNotifier extends AsyncNotifier<TaskSessionsState> {
  @override
  Future<TaskSessionsState> build() {
    return _loadState();
  }

  Future<void> startSession(String taskId) async {
    state = const AsyncLoading();

    final result = await ref.read(startTaskSessionUsecaseProvider)(
      StartTaskSessionUsecaseParams(taskId: taskId),
    );

    await result.fold(
      (failure) async {
        state = AsyncError(failure, StackTrace.current);
      },
      (_) async {
        state = AsyncData(await _loadState());
      },
    );
  }

  Future<void> finishCurrentSession() async {
    state = const AsyncLoading();

    final result = await ref.read(finishCurrentTaskSessionUsecaseProvider)(
      const NoParams(),
    );

    await result.fold(
      (failure) async {
        state = AsyncError(failure, StackTrace.current);
      },
      (_) async {
        state = AsyncData(await _loadState());
      },
    );
  }

  Future<TaskSessionsState> _loadState() async {
    final currentResult = await ref.read(getCurrentTaskSessionUsecaseProvider)(
      const NoParams(),
    );
    final completedResult = await ref.read(
      getCompletedTaskSessionsUsecaseProvider,
    )(const NoParams());

    final currentSession = currentResult.fold(
      (failure) => throw failure,
      (session) => session,
    );
    final completedSessions = completedResult.fold(
      (failure) => throw failure,
      (sessions) => sessions,
    );

    return TaskSessionsState(
      currentSession: currentSession,
      completedSessions: completedSessions,
    );
  }
}
