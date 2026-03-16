import 'dart:async';
import 'package:flutter/material.dart';
import '../data/local/app_database.dart';
import '../data/repositories/activity_repository.dart';

class ActivityProvider extends ChangeNotifier {
  final ActivityRepository repository;

  ActivityProvider(this.repository) {
    watchActivities();
  }

  List<Activity> _activities = [];
  List<Activity> get activities => _activities;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String _categoryFilter = 'All';
  String get categoryFilter => _categoryFilter;

  bool? _completedFilter;
  bool? get completedFilter => _completedFilter;

  StreamSubscription<List<Activity>>? _subscription;

  void watchActivities() {
    _subscription?.cancel();
    _subscription = repository.watchAllActivities().listen((data) {
      _activities = data;
      notifyListeners();
    });
  }

  List<Activity> get filteredActivities {
    return _activities.where((activity) {
      final matchesSearch =
          activity.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              (activity.description ?? '')
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase());

      final matchesCategory =
          _categoryFilter == 'All' || activity.category == _categoryFilter;

      final matchesCompleted = _completedFilter == null ||
          activity.isCompleted == _completedFilter;

      return matchesSearch && matchesCategory && matchesCompleted;
    }).toList();
  }

  void setSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void setCategoryFilter(String value) {
    _categoryFilter = value;
    notifyListeners();
  }

  void setCompletedFilter(bool? value) {
    _completedFilter = value;
    notifyListeners();
  }

  Future<void> deleteActivity(int id) async {
    await repository.removeActivity(id);
  }

  Future<void> updateActivity(Activity activity) async {
    await repository.updateExistingActivity(activity);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}