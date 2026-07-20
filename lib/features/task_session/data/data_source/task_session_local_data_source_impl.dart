import 'package:drift/drift.dart';
import 'package:uakyt/core/database/app_database.dart';
import 'package:uakyt/features/task_session/data/data_source/task_session_local_data_source.dart';
import 'package:uakyt/features/task_session/data/model/task_session_model.dart';

class TaskSessionLocalDataSourceImpl implements TaskSessionLocalDataSource {
  const TaskSessionLocalDataSourceImpl({required AppDatabase database})
    : _database = database;

  final AppDatabase _database;

  @override
  Future<TaskSessionModel> startSession(TaskSessionModel session) async {
    return _database.transaction(() async {
      final activeSession = await getCurrentSession();

      if (activeSession != null) {
        return activeSession;
      }

      await _database
          .into(_database.taskSessions)
          .insert(session.toCompanion());

      return session;
    });
  }

  @override
  Future<TaskSessionModel?> getCurrentSession() async {
    final row =
        await (_database.select(_database.taskSessions)
              ..where((table) => table.endedAt.isNull())
              ..limit(1))
            .getSingleOrNull();

    if (row == null) {
      return null;
    }

    return TaskSessionModel.fromDrift(row);
  }

  @override
  Future<List<TaskSessionModel>> getCompletedSessions() async {
    final rows =
        await (_database.select(_database.taskSessions)
              ..where((table) => table.endedAt.isNotNull())
              ..orderBy([
                (table) => OrderingTerm(
                  expression: table.endedAt,
                  mode: OrderingMode.desc,
                ),
              ]))
            .get();

    return rows.map(TaskSessionModel.fromDrift).toList();
  }

  @override
  Future<TaskSessionModel> finishCurrentSession(DateTime endedAt) async {
    final activeSession = await getCurrentSession();

    if (activeSession == null) {
      throw StateError('No active task session found.');
    }

    final finishedSession = TaskSessionModel(
      id: activeSession.id,
      taskId: activeSession.taskId,
      startedAt: activeSession.startedAt,
      endedAt: endedAt,
    );

    await (_database.update(_database.taskSessions)
          ..where((table) => table.id.equals(activeSession.id)))
        .write(finishedSession.toCompanion());

    return finishedSession;
  }
}
