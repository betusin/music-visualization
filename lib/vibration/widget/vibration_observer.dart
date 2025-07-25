import 'package:firebase_kit/collection_repo/firestore_repository.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/stream/widget/handling_stream_builder.dart';
import 'package:vibration_poc/common/ui_constants.dart';
import 'package:vibration_poc/ioc/ioc_container.dart';
import 'package:vibration_poc/vibration/model/vibration_metadata.dart';
import 'package:vibration_poc/vibration/model/vibration_status_enum.dart';
import 'package:vibration_poc/vibration/widget/vibration_switcher.dart';

class VibrationObserver extends StatelessWidget {
  final _vibrationMetadataRepo = get<FirestoreRepository<VibrationMetadata>>();

  final String deviceId;
  final Axis direction;
  final bool showVibrationStatus;

  VibrationObserver({
    super.key,
    required this.deviceId,
    this.direction = Axis.vertical,
    this.showVibrationStatus = true,
  });

  @override
  Widget build(BuildContext context) {
    return HandlingStreamBuilder(
      stream: _vibrationMetadataRepo.observeDocument(deviceId),
      builder: (context, vibrationMetadata) {
        final switcher = VibrationSwitcher(deviceId: deviceId);

        if (!showVibrationStatus) {
          return switcher;
        }

        return Flex(
          mainAxisAlignment: MainAxisAlignment.center,
          direction: direction,
          spacing: smallGapSize,
          children: [
            switcher,
            vibrationMetadata == null
                ? Text('No audio playing currently')
                : _buildVibrationStatus(vibrationMetadata.vibrationStatus),
          ],
        );
      },
    );
  }

  Widget _buildVibrationStatus(VibrationStatus status) {
    final iconData = switch (status) {
      VibrationStatus.playing => Icons.play_arrow,
      VibrationStatus.finished => Icons.check_circle,
      VibrationStatus.paused => Icons.pause_circle_filled,
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: smallGapSize,
      children: [
        Icon(iconData),
        Text(status.value),
      ],
    );
  }
}
