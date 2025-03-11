import 'package:flutter/material.dart';
import 'package:vibration_poc/animation/music_animation.dart';
import 'package:vibration_poc/recorder/widget/simple_recorder.dart';

class AnimationWithVibration extends StatelessWidget {
  const AnimationWithVibration({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: SimpleRecorder()),
        Expanded(child: MusicAnimation()),
      ],
    );
  }
}
