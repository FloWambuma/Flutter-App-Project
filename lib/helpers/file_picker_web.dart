import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

class WebFilePicker {
  static Future<Map<String, dynamic>?> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null && result.files.isNotEmpty) {
        return {
          "bytes": result.files.first.bytes, // For web upload
          "name": result.files.first.name,
        };
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
