import 'package:flutter/material.dart';
import 'package:p5/model/vector.dart';
import 'package:p5/painter.dart';
import 'package:vibration_poc/ioc/ioc_container.dart';
import 'package:vibration_poc/recorder/service/recorder_controller.dart';

const _strokeWeight = 2;

class AmplitudeSketch extends Painter {
  static double xPosition = 0;
  final _recorderController = get<RecorderController>();
  final amplitudes = <double>[];
  var amplitudeStrokes = <List<PVector>>[];

  @override
  void setup() {
    fullScreen();
    updateAmplitudes();
  }

  @override
  void draw() {
    background(color(255, 255, 255));

    noFill();
    strokeWeight(_strokeWeight);
    stroke(Colors.red);

    beginShape();

    for (final (i, amplitude) in amplitudes.indexed) {
      final y = pMap(amplitude, minAmplitudeValue, maxAmplitudeValue, height, 0);
      vertex(i, y);
    }

    endShape();
  }

  Future<void> updateAmplitudes() async {
    await for (final future in _recorderController.getAmplitudePeriodicStream()) {
      final amplitudeData = await future;
      if (amplitudeData != null) {
        amplitudes.add(amplitudeData.current);
        if (amplitudes.length > width) {
          amplitudes.removeAt(0);
        }
      }
    }
  }
}
