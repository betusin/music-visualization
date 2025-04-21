// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pair_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PairData _$PairDataFromJson(Map<String, dynamic> json) => PairData(
      id: json['id'] as String,
      pairCode: json['pairCode'] as String,
      deviceId: json['deviceId'] as String,
      watchId: json['watchId'] as String?,
      confirmed: json['confirmed'] as bool,
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp),
    );

Map<String, dynamic> _$PairDataToJson(PairData instance) => <String, dynamic>{
      'id': instance.id,
      'pairCode': instance.pairCode,
      'deviceId': instance.deviceId,
      'watchId': instance.watchId,
      'confirmed': instance.confirmed,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };
