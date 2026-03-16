import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/activity_repository.dart';
import '../../../core/utils/date_formatter.dart';

class ActivityDetailsScreen extends StatelessWidget {
  final int activityId;

  const ActivityDetailsScreen({super.key, required this.activityId});

  @override
  Widget build(BuildContext context) {
    final repository = context.read<ActivityRepository>();

    return FutureBuilder(
      future: repository.getById(activityId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final activity = snapshot.data;
        if (activity == null) {
          return const Scaffold(
            body: Center(child: Text('Activity not found')),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Activity Details')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (activity.imagePath != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(activity.imagePath!),
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                activity.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(activity.description ?? 'No description'),
              const SizedBox(height: 16),
              Text('Category: ${activity.category}'),
              Text('Completed: ${activity.isCompleted ? "Yes" : "No"}'),
              Text('Important: ${activity.isImportant ? "Yes" : "No"}'),
              Text('Created: ${formatDateTime(activity.createdAt)}'),
              if (activity.updatedAt != null)
                Text('Updated: ${formatDateTime(activity.updatedAt!)}'),
            ],
          ),
        );
      },
    );
  }
}