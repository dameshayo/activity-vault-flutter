import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'tables/activity_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Activities])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Activity>> getAllActivities() {
    return (select(activities)
          ..orderBy([
            (tbl) => OrderingTerm(
                  expression: tbl.createdAt,
                  mode: OrderingMode.desc,
                ),
          ]))
        .get();
  }

  Stream<List<Activity>> watchAllActivities() {
    return (select(activities)
          ..orderBy([
            (tbl) => OrderingTerm(
                  expression: tbl.createdAt,
                  mode: OrderingMode.desc,
                ),
          ]))
        .watch();
  }

  Future<int> insertActivity(ActivitiesCompanion entry) {
    return into(activities).insert(entry);
  }

  Future<bool> updateActivity(Activity activity) {
    return update(activities).replace(activity);
  }

  Future<int> deleteActivity(int id) {
    return (delete(activities)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<Activity?> getActivityById(int id) {
    return (select(activities)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'activity_tracker.sqlite'));
    return NativeDatabase(file);
  });
}