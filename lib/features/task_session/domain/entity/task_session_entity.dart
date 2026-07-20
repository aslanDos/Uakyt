import 'package:equatable/equatable.dart';

class TaskSessionEntity extends Equatable {
  const TaskSessionEntity({
    required this.id,
    required this.taskId,
    required this.startedAt,
    this.endedAt,
  });

  final String id;
  final String taskId;
  final DateTime startedAt;
  final DateTime? endedAt;

  bool get isActive => endedAt == null;

  Duration duration({DateTime? now}) {
    return (endedAt ?? now ?? DateTime.now()).difference(startedAt);
  }

  TaskSessionEntity copyWith({
    String? id,
    String? taskId,
    DateTime? startedAt,
    DateTime? endedAt,
  }) {
    return TaskSessionEntity(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
    );
  }

  @override
  List<Object?> get props => [id, taskId, startedAt, endedAt];
}
