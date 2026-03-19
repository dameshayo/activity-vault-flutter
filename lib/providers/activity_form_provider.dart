import 'dart:io';

import 'package:activity_tracker/services/image_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ActivityFormProvider extends ChangeNotifier {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  String? imagePath;
  bool isCompleted = false;
  bool isImportant = false;
  String category = 'Other';
  final ImagePicker _picker = ImagePicker();
  final ImageStorageService _storageService = ImageStorageService();

  void setImage(String? path) {
    imagePath = path;
    notifyListeners();
  }

  void setCompleted(bool value) {
    isCompleted = value;
    notifyListeners();
  }

  void removeImage() {
    imagePath = null;
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

  /// Pick from camera
  Future<void> pickFromCamera() async {
    final XFile? file =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 70);

    if (file != null) {
      final savedPath = await _storageService.saveImage(File(file.path));

      imagePath = savedPath;
      notifyListeners();
    }
  }

  /// Pick from gallery
  Future<void> pickFromGallery() async {
    final XFile? file =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (file != null) {
      final savedPath = await _storageService.saveImage(File(file.path));

      imagePath = savedPath;
      notifyListeners();
    }
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
