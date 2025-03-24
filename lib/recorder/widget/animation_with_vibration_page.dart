import 'package:flutter/material.dart';
import 'package:vibration_poc/web_view/widget/web_page_display.dart';

class AnimationWithVibration extends StatelessWidget {
  const AnimationWithVibration({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Expanded(child: SimpleRecorder()),
        // Expanded(child: MusicAnimation()),
        // Expanded(child: WebPageDisplay(url: 'https://flutter.dev')),
        Expanded(child: WebPageDisplay(url: 'http://192.168.1.105:3000/')),
      ],
    );
  }
}
