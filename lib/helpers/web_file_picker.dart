// lib/helpers/web_file_picker.dart
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';

class WebFilePicker {
  /// Opens a file picker in web environments
  /// Returns the selected file's bytes (Uint8List) or null if cancelled
  static Future<Uint8List?> pickFile() async {
    if (!kIsWeb) return null;

    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      return result.files.first.bytes;
    }
    return null;
  }
}
