import 'package:json_annotation/json_annotation.dart';
import 'package:master_kit/contracts/identifiable_serializable.dart';

part 'vibration_metadata.g.dart';

@JsonSerializable()
class VibrationMetadata implements IdentifiableSerializable {
  @override
  final String id;

  /// beat in milliseconds, define delay between amplitudes
  final int beat;

  /// amplitudes of vibration in dbFs
  final List<double> amplitudes;

  const VibrationMetadata(this.id, this.beat, this.amplitudes);

  @override
  Map<String, dynamic> toJson() => _$VibrationMetadataToJson(this);

  factory VibrationMetadata.fromJson(Map<String, dynamic> json) => _$VibrationMetadataFromJson(json);
}
