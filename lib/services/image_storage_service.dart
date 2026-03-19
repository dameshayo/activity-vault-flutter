import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ImageStorageService {
  Future<String> saveImage(File image) async {
    final directory = await getApplicationDocumentsDirectory();

    final imagesDir = Directory('${directory.path}/images');

    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    final fileName =
        'img_${DateTime.now().millisecondsSinceEpoch}${p.extension(image.path)}';

    final savedImage = await image.copy('${imagesDir.path}/$fileName');

    return savedImage.path;
  }
}
