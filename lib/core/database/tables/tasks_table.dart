import 'package:drift/drift.dart';

@DataClassName('TaskRow')
class Tasks extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  TextColumn get iconName => text()();

  IntColumn get colorValue => integer()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime().nullable()();

  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
