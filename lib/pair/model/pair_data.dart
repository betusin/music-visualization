import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:master_kit/contracts/identifiable_serializable.dart';
import 'package:vibration_poc/json/util/timestamp_converter.dart';

part 'pair_data.g.dart';

@JsonSerializable()
class PairData implements IdentifiableSerializable {
  @override
  final String id;
  final String pairCode; // 6-digit pairing code
  final String deviceId; // ID of the mobile device
  final String? watchId; // Optional, filled when watch pairs
  final bool confirmed; // Whether mobile confirmed pairing
  @TimestampConverter()
  final DateTime createdAt;

  const PairData({
    required this.id,
    required this.pairCode,
    required this.deviceId,
    this.watchId,
    required this.confirmed,
    required this.createdAt,
  });

  @override
  Map<String, dynamic> toJson() => _$PairDataToJson(this);

  factory PairData.fromJson(Map<String, dynamic> json) => _$PairDataFromJson(json);
}
