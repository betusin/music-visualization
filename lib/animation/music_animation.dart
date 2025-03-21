import 'package:flutter/material.dart';
import 'package:p5/animator.dart';
import 'package:p5/painter.dart';
import 'package:p5/widget/pwidget.dart';
import 'package:vibration_poc/animation/amplitude_sketch.dart';

class MusicAnimation extends StatefulWidget {
  const MusicAnimation({super.key});

  @override
  State<MusicAnimation> createState() => _MusicAnimationState();
}

class _MusicAnimationState extends State<MusicAnimation> with SingleTickerProviderStateMixin {
  late final Painter sketch;
  late final PAnimator animator;

  @override
  void initState() {
    super.initState();
    sketch = AmplitudeSketch();
    // Need an animator to call the draw() method in the sketch continuously,
    // otherwise it will be called only when touch events are detected.
    animator = PAnimator(this);
    animator.addListener(() {
      setState(() => sketch.redraw());
    });
    animator.run();
  }

  @override
  Widget build(BuildContext context) {
    return PWidget(sketch);
  }
}
