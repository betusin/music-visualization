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

    var previousVectorAmplitude = PVector(0, height.toDouble());

    for (final amplitude in amplitudes) {
      final amplitudeVector =
          PVector(previousVectorAmplitude.x + 1, height.toDouble() - previousVectorAmplitude.y + amplitude);

      line(
        previousVectorAmplitude.x * _strokeWeight,
        previousVectorAmplitude.y,
        amplitudeVector.x * _strokeWeight,
        amplitudeVector.y,
      );

      previousVectorAmplitude = amplitudeVector;
    }
  }

  Future<void> updateAmplitudes() async {
    await for (final future in _recorderController.getAmplitudePeriodicStream()) {
      final amplitudeData = await future;
      if (amplitudeData != null) {
        final amplitude = (await _recorderController.getAmplitude()).current + 160;
        amplitudes.add(amplitude);
      }
    }
  }
}
