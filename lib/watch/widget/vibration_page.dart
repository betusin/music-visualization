import 'package:flutter/material.dart';
import 'package:vibration_poc/vibration/widget/vibration_observer.dart';
import 'package:vibration_poc/watch/widget/page_wrapper.dart';

class VibrationPage extends StatelessWidget {
  const VibrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO(betka): get that from pairLinks
    final deviceId = "KZGzluk34KRuPm1kEle85UsvAnf2";

    return PageWrapper(
      child: Center(
        child: VibrationObserver(deviceId: deviceId),
      ),
    );
  }
}
