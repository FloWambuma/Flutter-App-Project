// lib/helpers/cloudinary_upload.dart
import 'dart:io' show File;
import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // for debugPrint
import 'package:cloudinary_public/cloudinary_public.dart';

class CloudinaryService {
  static final cloudinary = CloudinaryPublic(
    "your_cloud_name",   // 🔴 replace with your actual cloud name
    "your_upload_preset", // 🔴 replace with your actual upload preset
    cache: false,
  );

  /// Uploads an image to Cloudinary.
  /// Accepts either a [File] (mobile/desktop) or [Uint8List] (web).
  static Future<String?> uploadImage({File? file, Uint8List? bytes}) async {
    try {
      CloudinaryResponse response;

      if (file != null) {
        response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(file.path),
        );
      } else if (bytes != null) {
        response = await cloudinary.uploadFile(
          CloudinaryFile.fromBytesData(
            bytes,
            identifier: "upload_${DateTime.now().millisecondsSinceEpoch}.png",
          ),
        );
      } else {
        throw ArgumentError("Either file or bytes must be provided.");
      }

      return response.secureUrl;
    } catch (e, stack) {
      debugPrint("Cloudinary upload error: $e");
      debugPrintStack(stackTrace: stack);
      return null;
    }
  }

  /// ✅ Wrapper for web usage
  static Future<String?> uploadImageBytes(Uint8List bytes) async {
    return await uploadImage(bytes: bytes);
  }

  /// ✅ Wrapper for mobile/desktop usage
  static Future<String?> uploadImageFile(File file) async {
    return await uploadImage(file: file);
  }
}
