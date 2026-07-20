import 'package:drift/drift.dart';
import 'package:uakyt/core/database/app_database.dart';
import 'package:uakyt/features/task/domain/entity/task_entity.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.name,
    required super.iconName,
    required super.colorValue,
    required super.createdAt,
    super.updatedAt,
    super.isArchived,
  });

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      name: entity.name,
      iconName: entity.iconName,
      colorValue: entity.colorValue,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isArchived: entity.isArchived,
    );
  }

  factory TaskModel.fromDrift(TaskRow row) {
    return TaskModel(
      id: row.id,
      name: row.name,
      iconName: row.iconName,
      colorValue: row.colorValue,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      isArchived: row.isArchived,
    );
  }

  TasksCompanion toCompanion() {
    return TasksCompanion(
      id: Value(id),
      name: Value(name),
      iconName: Value(iconName),
      colorValue: Value(colorValue),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isArchived: Value(isArchived),
    );
  }
}
