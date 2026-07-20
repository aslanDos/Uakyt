import 'package:uakyt/features/task_session/data/model/task_session_model.dart';

abstract class TaskSessionLocalDataSource {
  Future<TaskSessionModel> startSession(TaskSessionModel session);
  Future<TaskSessionModel?> getCurrentSession();
  Future<List<TaskSessionModel>> getCompletedSessions();
  Future<TaskSessionModel> finishCurrentSession(DateTime endedAt);
}
