import 'package:flutter/material.dart';
import 'package:vibration_poc/recorder/widget/preset_visualization.dart';

class AnimationWithVibration extends StatelessWidget {
  const AnimationWithVibration({super.key});

  @override
  Widget build(BuildContext context) {
    return PresetVisualization();

    return Column(
      children: [
        // Expanded(child: SimpleRecorder()),
        // Expanded(child: MusicAnimation()),
        // Expanded(child: WebPageDisplay(url: 'https://flutter.dev')),
        // Expanded(
        //     child: WebPageDisplay(url: 'https://music-visualization-virid.vercel.app/visualization?file=$fileName')),
      ],
    );
  }
}
