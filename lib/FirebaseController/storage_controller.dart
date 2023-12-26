import 'dart:io';
import 'dart:typed_data';
import 'dart:html' as html;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class StorageController {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<bool> uploadImages(String id, List<XFile> images) async {
    bool allUploadsSuccessful = true;

    for (int index = 0; index < images.length; index++) {
      String fileName = '$id-$index';
      String fileExtension = images[index].name.split('.').last;

      try {
        Uint8List fileBytes;
        String filePath = 'images/$fileName.$fileExtension';

        if (kIsWeb) {
          // Handling for Flutter web
          fileBytes = await _getDataFromXFileWeb(images[index]);
        } else {
          // Handling for mobile
          File file = File(images[index].path);
          fileBytes = await file.readAsBytes();
        }

        // Upload to Firebase Storage
        await _storage.ref(filePath).putData(fileBytes);
        print('Uploaded $filePath successfully');
      } catch (e) {
        print('Error uploading file: $e');
        allUploadsSuccessful = false;
      }
    }

    return allUploadsSuccessful;
  }

  Future<Uint8List> _getDataFromXFileWeb(XFile file) async {
    final blob = html.Blob([await file.readAsBytes()]);
    final reader = html.FileReader();
    reader.readAsArrayBuffer(blob);
    await reader.onLoad.first;
    return reader.result as Uint8List;
  }
}
