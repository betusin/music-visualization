// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vibration_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VibrationMetadata _$VibrationMetadataFromJson(Map<String, dynamic> json) =>
    VibrationMetadata(
      id: json['id'] as String,
      beat: (json['beat'] as num).toInt(),
      amplitudes: (json['amplitudes'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      vibrationStatus: $enumDecodeNullable(
              _$VibrationStatusEnumMap, json['vibrationStatus']) ??
          VibrationStatus.playing,
    );

Map<String, dynamic> _$VibrationMetadataToJson(VibrationMetadata instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vibrationStatus': _$VibrationStatusEnumMap[instance.vibrationStatus]!,
      'beat': instance.beat,
      'amplitudes': instance.amplitudes,
    };

const _$VibrationStatusEnumMap = {
  VibrationStatus.playing: 'playing',
  VibrationStatus.finished: 'finished',
  VibrationStatus.paused: 'paused',
};
