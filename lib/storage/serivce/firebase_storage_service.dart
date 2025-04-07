import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

const _audioFolder = 'audio';

class FirebaseStorageService {
  final storage = FirebaseStorage.instanceFor(bucket: "gs://music-vis");

  void uploadFile(FilePickerResult result) {
    assert(result.count == 1);

    final platformFile = result.files.first;
    final fileName = platformFile.name;

    final fileRef = storage.ref().child('$_audioFolder/$fileName');
    // TODO(betka): try-catch
    fileRef.putFile(File(platformFile.path!));
  }
}
