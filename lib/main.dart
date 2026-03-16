import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'data/local/app_database.dart';
import 'data/repositories/activity_repository.dart';
import 'providers/activity_provider.dart';
import 'providers/activity_form_provider.dart';

void main() {
  final database = AppDatabase();
  final repository = ActivityRepository(database);

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: database),
        Provider<ActivityRepository>.value(value: repository),
        ChangeNotifierProvider(
          create: (_) => ActivityProvider(repository),
        ),
        ChangeNotifierProvider(
          create: (_) => ActivityFormProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}