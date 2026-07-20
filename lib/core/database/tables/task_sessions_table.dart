import 'package:drift/drift.dart';
import 'package:uakyt/core/database/tables/tasks_table.dart';

@DataClassName('TaskSessionRow')
class TaskSessions extends Table {
  TextColumn get id => text()();

  TextColumn get taskId => text().references(Tasks, #id)();

  DateTimeColumn get startedAt => dateTime()();

  DateTimeColumn get endedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
