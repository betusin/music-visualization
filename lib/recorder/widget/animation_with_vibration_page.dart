import 'package:flutter/material.dart';
import 'package:vibration_poc/animation/widget/music_animation.dart';
import 'package:vibration_poc/recorder/widget/simple_recorder.dart';
import 'package:vibration_poc/vibration/widget/vibration_switcher_and_adjuster.dart';

class AnimationWithVibration extends StatelessWidget {
  const AnimationWithVibration({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: SimpleRecorder()),
        VibrationSwitcherAndAdjuster(),
        Expanded(child: MusicAnimation()),
      ],
    );
  }
}
