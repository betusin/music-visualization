import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

const _audioFolder = 'audio';

class FirebaseStorageService {
  final storage = FirebaseStorage.instanceFor(bucket: "gs://music-vis");

  Future<String> uploadFile(FilePickerResult result) async {
    assert(result.count == 1);

    final platformFile = result.files.first;
    final encodedName = _encodeIdentifier(platformFile.name);
    final fileName = '$encodedName.${platformFile.extension}';

    final fileRef = storage.ref().child('$_audioFolder/$fileName');
    final doesFileExist = await _fileExists(fileRef);

    if (!doesFileExist) {
      // TODO(betka): try-catch
      fileRef.putFile(File(platformFile.path!));
    }

    return fileName;
  }

  Future<bool> _fileExists(Reference storageRef) async {
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

  String _encodeIdentifier(String input) {
    // Generate SHA-256 hash
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);

    // Convert the hash bytes to a base36 string (only a-z and 0-9)
    final bigInt = BigInt.parse(digest.toString(), radix: 16);
    return bigInt.toRadixString(36);
  }
}
