import 'package:json_annotation/json_annotation.dart';
import 'package:master_kit/contracts/identifiable_serializable.dart';
import 'package:vibration_poc/vibration/model/vibration_status_enum.dart';

part 'vibration_metadata.g.dart';

@JsonSerializable()
class VibrationMetadata implements IdentifiableSerializable {
  @override
  final String id;

  final VibrationStatus vibrationStatus;

  /// beat in milliseconds, define delay between amplitudes
  final int beat;

  /// amplitudes of vibration in dbFs
  final List<double> amplitudes;

  const VibrationMetadata({
    required this.id,
    required this.beat,
    required this.amplitudes,
    this.vibrationStatus = VibrationStatus.playing,
  });

  @override
  Map<String, dynamic> toJson() => _$VibrationMetadataToJson(this);

  factory VibrationMetadata.fromJson(Map<String, dynamic> json) => _$VibrationMetadataFromJson(json);
}
