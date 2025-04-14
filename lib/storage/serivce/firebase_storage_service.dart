import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

const _audioFolder = 'audio';

class FirebaseStorageService {
  final storage = FirebaseStorage.instanceFor(bucket: "gs://music-vis");

  Future<void> uploadFile(FilePickerResult result) async {
    assert(result.count == 1);

    final platformFile = result.files.first;
    final fileName = platformFile.name;

    final fileRef = storage.ref().child('$_audioFolder/$fileName');
    final doesFileExist = await fileExists(fileRef);

    if (doesFileExist) {
      // TODO(betka): try-catch
      fileRef.putFile(File(platformFile.path!));
    }
  }

  Future<bool> fileExists(Reference storageRef) async {
    try {
      await storageRef.getMetadata();
      return true;
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        return false;
      } else {
        rethrow;
      }
    }
  }
}
