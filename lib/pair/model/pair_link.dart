import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:master_kit/contracts/identifiable_serializable.dart';
import 'package:vibration_poc/json/util/timestamp_converter.dart';

part 'pair_link.g.dart';

@JsonSerializable()
class PairLink implements IdentifiableSerializable {
  static const statusKey = 'status';
  static const deviceIdKey = 'deviceId';
  static const watchIdKey = 'watchId';
  static const timestampKey = 'createdAt';

  @override
  final String id;
  @JsonKey(name: deviceIdKey)
  final String deviceId; // uid of the user logged in on mobile device
  final String deviceName; // name of mobile model
  @JsonKey(name: watchIdKey)
  final String watchId; // uid of the user logged in on watch device
  @TimestampConverter()
  @JsonKey(name: timestampKey)
  final DateTime createdAt;

  const PairLink({
    required this.id,
    required this.deviceId,
    required this.deviceName,
    required this.watchId,
    required this.createdAt,
  });

  @override
  Map<String, dynamic> toJson() => _$PairLinkToJson(this);

  factory PairLink.fromJson(Map<String, dynamic> json) => _$PairLinkFromJson(json);
}
