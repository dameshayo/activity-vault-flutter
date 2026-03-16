import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/local/app_database.dart';
import '../../../data/repositories/activity_repository.dart';

class EditActivityScreen extends StatefulWidget {
  final int activityId;

  const EditActivityScreen({super.key, required this.activityId});

  @override
  State<EditActivityScreen> createState() => _EditActivityScreenState();
}

class _EditActivityScreenState extends State<EditActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  bool isCompleted = false;
  bool isImportant = false;
  String category = 'Other';
  Activity? activity;

  @override
  void initState() {
    super.initState();
    _loadActivity();
  }

  Future<void> _loadActivity() async {
    final repository = context.read<ActivityRepository>();
    final result = await repository.getById(widget.activityId);
    if (result != null) {
      setState(() {
        activity = result;
        titleController.text = result.title;
        descriptionController.text = result.description ?? '';
        isCompleted = result.isCompleted;
        isImportant = result.isImportant;
        category = result.category;
      });
    }
  }

  Future<void> _updateActivity() async {
    if (!_formKey.currentState!.validate() || activity == null) return;

    final repository = context.read<ActivityRepository>();

    final updated = activity!.copyWith(
      title: titleController.text.trim(),
      description: Value(descriptionController.text.trim()),
      isCompleted: isCompleted,
      isImportant: isImportant,
      category: category,
      updatedAt: Value(DateTime.now()),
    );

    await repository.updateExistingActivity(updated);

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (activity == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Activity')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Title required'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: category,
                items: const [
                  DropdownMenuItem(value: 'Work', child: Text('Work')),
                  DropdownMenuItem(value: 'Exercise', child: Text('Exercise')),
                  DropdownMenuItem(value: 'Study', child: Text('Study')),
                  DropdownMenuItem(value: 'Personal', child: Text('Personal')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => category = value);
                },
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
              ),
              SwitchListTile(
                value: isCompleted,
                onChanged: (value) => setState(() => isCompleted = value),
                title: const Text('Completed'),
              ),
              SwitchListTile(
                value: isImportant,
                onChanged: (value) => setState(() => isImportant = value),
                title: const Text('Important'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateActivity,
                child: const Text('Update Activity'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
