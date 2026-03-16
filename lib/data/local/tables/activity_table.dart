import 'package:drift/drift.dart';

class Activities extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text().withLength(min: 1, max: 100)();

  TextColumn get description => text().nullable()();

  TextColumn get imagePath => text().nullable()();

  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  BoolColumn get isImportant => boolean().withDefault(const Constant(false))();

  TextColumn get category => text().withDefault(const Constant('Other'))();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime().nullable()();
}
