import 'package:flutter/material.dart';
import 'package:vibration_poc/recorder/widget/preset_visualization.dart';
import 'package:vibration_poc/watch/widget/page_wrapper.dart';

// TODO(betka): get chosen songs
const _songIdentifiers = ['12.mp3', '124.mp3'];

class SteppedTaskPage extends StatefulWidget {
  const SteppedTaskPage({super.key});

  @override
  State<SteppedTaskPage> createState() => _SteppedTaskPageState();
}

class _SteppedTaskPageState extends State<SteppedTaskPage> {
  // TODO(betka): move these to controller?
  int _currentStep = 0;
  bool _isGuessing = false;

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      title: 'Song Guessing - Step ${_currentStep + 1}',
      child: PresetVisualization(
        initialFileId: _songIdentifiers[_currentStep],
        showFilePicker: false,
        showVibration: false,
      ),
    );
  }
}
