// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pair_link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PairLink _$PairLinkFromJson(Map<String, dynamic> json) => PairLink(
      id: json['id'] as String,
      deviceId: json['deviceId'] as String,
      deviceName: json['deviceName'] as String,
      watchId: json['watchId'] as String,
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp),
    );

Map<String, dynamic> _$PairLinkToJson(PairLink instance) => <String, dynamic>{
      'id': instance.id,
      'deviceId': instance.deviceId,
      'deviceName': instance.deviceName,
      'watchId': instance.watchId,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };
