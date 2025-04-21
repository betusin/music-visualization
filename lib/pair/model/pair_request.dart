import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:master_kit/contracts/identifiable_serializable.dart';
import 'package:vibration_poc/json/util/timestamp_converter.dart';
import 'package:vibration_poc/pair/enum/pair_request_status.dart';

part 'pair_request.g.dart';

@JsonSerializable()
class PairRequest implements IdentifiableSerializable {
  static const statusKey = 'status';
  static const deviceIdKey = 'deviceId';

  @override
  final String id;
  final int code; // 6-digit pairing code
  @JsonKey(name: deviceIdKey)
  final String deviceId; // uid of the user logged in on mobile device
  @JsonKey(name: statusKey)
  final PairRequestStatus status;
  @TimestampConverter()
  final DateTime createdAt;

  const PairRequest({
    required this.id,
    required this.code,
    required this.deviceId,
    this.status = PairRequestStatus.pending,
    required this.createdAt,
  });

  @override
  Map<String, dynamic> toJson() => _$PairRequestToJson(this);

  factory PairRequest.fromJson(Map<String, dynamic> json) => _$PairRequestFromJson(json);
}
