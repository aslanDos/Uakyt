import 'package:drift/drift.dart';
import 'package:uakyt/core/database/app_database.dart';
import 'package:uakyt/features/task_session/domain/entity/task_session_entity.dart';

class TaskSessionModel extends TaskSessionEntity {
  const TaskSessionModel({
    required super.id,
    required super.taskId,
    required super.startedAt,
    super.endedAt,
  });

  factory TaskSessionModel.fromEntity(TaskSessionEntity entity) {
    return TaskSessionModel(
      id: entity.id,
      taskId: entity.taskId,
      startedAt: entity.startedAt,
      endedAt: entity.endedAt,
    );
  }

  factory TaskSessionModel.fromDrift(TaskSessionRow row) {
    return TaskSessionModel(
      id: row.id,
      taskId: row.taskId,
      startedAt: row.startedAt,
      endedAt: row.endedAt,
    );
  }

  TaskSessionsCompanion toCompanion() {
    return TaskSessionsCompanion(
      id: Value(id),
      taskId: Value(taskId),
      startedAt: Value(startedAt),
      endedAt: Value(endedAt),
    );
  }
}
