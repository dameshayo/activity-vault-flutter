import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/local/app_database.dart';
import '../../../data/repositories/activity_repository.dart';
import '../../../providers/activity_form_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _saveActivity() async {
    final formProvider = context.read<ActivityFormProvider>();
    final repository = context.read<ActivityRepository>();

    if (!_formKey.currentState!.validate()) return;

    await repository.addActivity(
      ActivitiesCompanion.insert(
        title: formProvider.titleController.text.trim(),
        description: drift.Value(
          formProvider.descriptionController.text.trim().isEmpty
              ? null
              : formProvider.descriptionController.text.trim(),
        ),
        imagePath: drift.Value(formProvider.imagePath),
        isCompleted: drift.Value(formProvider.isCompleted),
        isImportant: drift.Value(formProvider.isImportant),
        category: drift.Value(formProvider.category),
        createdAt: DateTime.now(),
        updatedAt: const drift.Value(null),
      ),
    );

    formProvider.clearForm();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Activity saved successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formProvider = context.watch<ActivityFormProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Activity'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: formProvider.titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: formProvider.descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: formProvider.category,
                items: const [
                  DropdownMenuItem(value: 'Work', child: Text('Work')),
                  DropdownMenuItem(value: 'Exercise', child: Text('Exercise')),
                  DropdownMenuItem(value: 'Study', child: Text('Study')),
                  DropdownMenuItem(value: 'Personal', child: Text('Personal')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                ],
                onChanged: (value) {
                  if (value != null) formProvider.setCategory(value);
                },
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                value: formProvider.isCompleted,
                onChanged: formProvider.setCompleted,
                title: const Text('Completed'),
              ),
              SwitchListTile(
                value: formProvider.isImportant,
                onChanged: formProvider.setImportant,
                title: const Text('Important'),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _saveActivity,
                child: const Text('Save Activity'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
