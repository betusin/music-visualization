// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vibration_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VibrationMetadata _$VibrationMetadataFromJson(Map<String, dynamic> json) =>
    VibrationMetadata(
      json['id'] as String,
      (json['beat'] as num).toInt(),
      (json['amplitudes'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$VibrationMetadataToJson(VibrationMetadata instance) =>
    <String, dynamic>{
      'id': instance.id,
      'beat': instance.beat,
      'amplitudes': instance.amplitudes,
    };
