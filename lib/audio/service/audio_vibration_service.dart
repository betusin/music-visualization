import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/ffprobe_kit.dart';
import 'package:master_kit/util/random_id_generator.dart';
import 'package:vibration_poc/vibration/model/audio_properties.dart';
import 'package:vibration_poc/vibration/model/vibration_metadata.dart';

class AudioVibrationService {
  Future<VibrationMetadata?> convertAudioFileToVibration(String filePath) async {
    final audioProps = await _getAudioProperties(filePath);

    if (audioProps == null) {
      // TODO(betka): better error handling
      return null;
    }

    final pcmData = await _decodeAudioToPcm(filePath);
    if (pcmData == null) {
      return null;
    }
    return _mapPcmDataToVibration(pcmData: pcmData, audioProps: audioProps, delay: Duration(milliseconds: 500));
  }

  Future<AudioProperties?> _getAudioProperties(String filePath) async {
    final session = await FFprobeKit.getMediaInformation(filePath);
    final info = session.getMediaInformation();

    if (info != null) {
      final streams = info.getStreams();
      if (streams.isNotEmpty) {
        final streamInfo = streams.first;
        final sampleRateStr = streamInfo.getSampleRate();
        final channelLayout = streamInfo.getChannelLayout();
        final channelsDynamic = streamInfo.getAllProperties()?['channels'];

        final sampleRate = int.tryParse(sampleRateStr ?? '');

        if (sampleRate == null || channelsDynamic is! int) {
          return null;
        }
        return AudioProperties(sampleRate: sampleRate, channels: channelsDynamic, channelLayout: channelLayout);
      }
    }
    return null;
  }

  Future<Uint8List?> _decodeAudioToPcm(String audioFilePath) async {
    final tempDir = Directory.systemTemp;

    final pcmPath = '${tempDir.path}/output.pcm';

    // Decode audio file to raw 16-bit little-endian PCM
    await FFmpegKit.execute('-i "$audioFilePath" -f s16le -acodec pcm_s16le -ac 1 -ar 44100 "$pcmPath"');

    final pcmFile = File(pcmPath);
    if (await pcmFile.exists()) {
      return await pcmFile.readAsBytes();
    }
    return null;
  }

  VibrationMetadata _mapPcmDataToVibration({
    required Uint8List pcmData,
    required AudioProperties audioProps,
    Duration delay = const Duration(seconds: 1),
  }) {
    const bytesPerSample = 2; // 16-bit = 2 bytes
    // TODO(betka): should be this, but then the length of audio did not match
    // final channels = audioProps.channels;
    const channels = 1;
    final bytesPerSecond = audioProps.sampleRate * bytesPerSample * channels;
    final bytesPerDelay = (bytesPerSecond * delay.inMilliseconds) ~/ 1000;

    final totalChunks = pcmData.length ~/ bytesPerDelay;

    final amplitudes = <double>[];

    for (int i = 0; i < totalChunks; i++) {
      final start = i * bytesPerDelay;
      final end = start + bytesPerDelay;
      final chunk = pcmData.sublist(start, end);
      final amplitude = _getAmplitude(chunk);
      amplitudes.add(amplitude);
    }

    return VibrationMetadata(
      id: generateRandomString(),
      beat: delay.inMilliseconds,
      amplitudes: amplitudes,
    );
  }

  double _getAmplitude(Uint8List chunk) {
    int max = -160;

    // Create a buffer from the chunk, and read it as little endian shorts
    final byteData = ByteData.sublistView(chunk);
    final buf = List.generate(chunk.length ~/ 2, (i) => byteData.getInt16(i * 2, Endian.little));

    for (var b in buf) {
      int curSample = b.abs();
      if (curSample > max) {
        max = curSample;
      }
    }

    // Convert to full scale decibels
    return 20 * log(max / 32767.0) / ln10;
  }
}
