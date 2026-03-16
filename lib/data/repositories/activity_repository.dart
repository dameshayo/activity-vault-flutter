import '../local/app_database.dart';

class ActivityRepository {
  final AppDatabase db;

  ActivityRepository(this.db);

  Stream<List<Activity>> watchAllActivities() => db.watchAllActivities();

  Future<List<Activity>> getAllActivities() => db.getAllActivities();

  Future<int> addActivity(ActivitiesCompanion activity) =>
      db.insertActivity(activity);

  Future<bool> updateExistingActivity(Activity activity) =>
      db.updateActivity(activity);

  Future<int> removeActivity(int id) => db.deleteActivity(id);

  Future<Activity?> getById(int id) => db.getActivityById(id);
}