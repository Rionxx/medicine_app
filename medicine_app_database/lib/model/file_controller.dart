import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class FileController {
  static Future get localPath async {
    if (Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    }
  }

  static Future getImagePath(XFile pickedFile) async {
    final imageFile = File(pickedFile.path);
    final path = await localPath;

    final imagePath = '$path/medicine.png';
    final copiedImageFile = await imageFile.copy(imagePath);
    return copiedImageFile;
  }
}