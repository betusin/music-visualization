// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pair_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PairRequest _$PairRequestFromJson(Map<String, dynamic> json) => PairRequest(
      id: json['id'] as String,
      code: (json['code'] as num).toInt(),
      deviceId: json['deviceId'] as String,
      watchId: json['watchId'] as String?,
      status: $enumDecodeNullable(_$PairRequestStatusEnumMap, json['status']) ??
          PairRequestStatus.pending,
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp),
    );

Map<String, dynamic> _$PairRequestToJson(PairRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'deviceId': instance.deviceId,
      'watchId': instance.watchId,
      'status': _$PairRequestStatusEnumMap[instance.status]!,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };

const _$PairRequestStatusEnumMap = {
  PairRequestStatus.pending: 'pending',
  PairRequestStatus.waitingForConfirmation: 'waitingForConfirmation',
  PairRequestStatus.accepted: 'accepted',
  PairRequestStatus.rejected: 'rejected',
};
