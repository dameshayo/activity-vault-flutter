import 'dart:io';

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
              // Image preview
if (formProvider.imagePath != null) ...[
  ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: Image.file(
      File(formProvider.imagePath!),
      height: 180,
      width: double.infinity,
      fit: BoxFit.cover,
    ),
  ),
  const SizedBox(height: 10),
  TextButton.icon(
    onPressed: formProvider.removeImage,
    icon: const Icon(Icons.delete, color: Colors.red),
    label: const Text('Remove Image'),
  ),
  const SizedBox(height: 10),
],

// Pick image buttons
Row(
  children: [
    Expanded(
      child: ElevatedButton.icon(
        onPressed: formProvider.pickFromCamera,
        icon: const Icon(Icons.camera_alt),
        label: const Text('Camera'),
      ),
    ),
    const SizedBox(width: 10),
    Expanded(
      child: ElevatedButton.icon(
        onPressed: formProvider.pickFromGallery,
        icon: const Icon(Icons.photo),
        label: const Text('Gallery'),
      ),
    ),
  ],
),
const SizedBox(height: 20),
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
