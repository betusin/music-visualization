import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:master_kit/contracts/identifiable_serializable.dart';
import 'package:vibration_poc/json/util/timestamp_converter.dart';
import 'package:vibration_poc/vibration/model/vibration_status_enum.dart';

part 'vibration_metadata.g.dart';

@JsonSerializable()
class VibrationMetadata implements IdentifiableSerializable {
  static const String startAtKey = 'startAt';
  @override
  final String id;

  final VibrationStatus vibrationStatus;

  /// beat in milliseconds, defines delay between amplitudes
  final int beat;

  /// amplitudes of vibration in range 1 to 255
  final List<double> amplitudes;

  // when the vibration should start (for synchronization purposes)
  @TimestampConverter()
  @JsonKey(name: startAtKey)
  final DateTime startAt;

  const VibrationMetadata({
    required this.id,
    required this.beat,
    required this.amplitudes,
    required this.startAt,
    this.vibrationStatus = VibrationStatus.playing,
  });

  const VibrationMetadata.fromBpm({
    required this.id,
    required int bpm,
    required this.amplitudes,
    this.vibrationStatus = VibrationStatus.playing,
    required this.startAt,
  }) : beat = 60000 ~/ bpm;

  @override
  Map<String, dynamic> toJson() => _$VibrationMetadataToJson(this);

  factory VibrationMetadata.fromJson(Map<String, dynamic> json) => _$VibrationMetadataFromJson(json);
}
