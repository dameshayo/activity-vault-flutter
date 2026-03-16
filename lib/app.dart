import 'package:flutter/material.dart';
import 'package:activity_tracker/core/theme/app_theme.dart';
import 'package:activity_tracker/core/router/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Activity Tracker',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}