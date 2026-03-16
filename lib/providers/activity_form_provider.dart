import 'package:flutter/material.dart';

class ActivityFormProvider extends ChangeNotifier {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  String? imagePath;
  bool isCompleted = false;
  bool isImportant = false;
  String category = 'Other';

  void setImage(String? path) {
    imagePath = path;
    notifyListeners();
  }

  void setCompleted(bool value) {
    isCompleted = value;
    notifyListeners();
  }

  void setImportant(bool value) {
    isImportant = value;
    notifyListeners();
  }

  void setCategory(String value) {
    category = value;
    notifyListeners();
  }

  void clearForm() {
    titleController.clear();
    descriptionController.clear();
    imagePath = null;
    isCompleted = false;
    isImportant = false;
    category = 'Other';
    notifyListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}