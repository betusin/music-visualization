import 'dart:math';
import 'dart:typed_data';

const _silentLevelDb = -160.0;
const _maxPCMValue = 32767; // Max 16-bit PCM value

class AudioConversionUtil {
  AudioConversionUtil._();

  static double calculateDecibels(Uint8List audioBytes) {
    if (audioBytes.length % 2 != 0) {
      throw ArgumentError("Invalid PCM16 data length");
    }
    // if (audioBytes.isEmpty) {
    //   return _silentLevelDb;
    // }

    final samples = Int16List.view(audioBytes.buffer);

    // Compute RMS (Root Mean Square)
    // TODO(betka): can be done with map
    double sum = 0;
    for (var sample in samples) {
      sum += sample * sample;
    }
    double rms = sqrt(sum / samples.length);

    // Convert RMS to dB
    // final db = 20 * log(rms / _maxPCMValue) / ln10;
    final db = 20 * log(rms) / ln10;

    return db.isFinite ? db : _silentLevelDb;
  }

  static double copilotDecibels(Uint8List audioBytes) {
    final samples = convertBytesToInt16(audioBytes);

    // Calculate RMS (Root Mean Square)
    final rms = sqrt(samples.map((sample) => sample * sample).reduce((a, b) => a + b) / samples.length);

    // Convert RMS to decibels
    final decibels = 20 * log(rms) / ln10;
    // final decibels = 20 * log(rms / _maxPCMValue) / ln10;

    return decibels;
  }

  /// Utility method to get PCM data as signed 16 bits integers.
  static List<int> convertBytesToInt16(Uint8List bytes, [endian = Endian.little]) {
    final values = <int>[];

    final data = ByteData.view(bytes.buffer);

    for (var i = 0; i < bytes.length; i += 2) {
      int short = data.getInt16(i, endian);
      values.add(short);
    }

    return values;
  }
}
