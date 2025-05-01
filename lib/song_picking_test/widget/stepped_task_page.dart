import 'dart:math';

import 'package:flutter/material.dart';
import 'package:master_kit/sdk_extension/iterable/iterable_extension.dart';
import 'package:vibration_poc/common/ui_constants.dart';
import 'package:vibration_poc/common/widget/main_page.dart';
import 'package:vibration_poc/ioc/ioc_container.dart';
import 'package:vibration_poc/recorder/widget/preset_visualization.dart';
import 'package:vibration_poc/vibration/service/amplitude_vibration_service.dart';
import 'package:vibration_poc/watch/widget/page_wrapper.dart';

// TODO(betka): get chosen songs
const _songIdentifiers = ['12.mp3', '124.mp3'];
const _songNames = ['New Balance', 'The Dude'];
final _count = _songIdentifiers.length;

final _shuffledOptions = List.from(_songNames)..shuffle(Random());

class SteppedTaskPage extends StatefulWidget {
  const SteppedTaskPage({super.key});

  @override
  State<SteppedTaskPage> createState() => _SteppedTaskPageState();
}

class _SteppedTaskPageState extends State<SteppedTaskPage> {
  final _amplitudeVibrationService = get<AmplitudeVibrationService>();

  // TODO(betka): move these to controller?
  int _currentStep = 0;
  int _correctAnswers = 0;
  bool _isGuessing = false;
  String? _currentlySelectedOption;

  bool get _finishedTest => _currentStep >= _count;

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      title: _finishedTest ? null : 'Song ${_isGuessing ? 'Guessing' : 'Playing'} - Step ${_currentStep + 1}',
      floatingActionButton: _finishedTest || _isGuessing && _currentlySelectedOption == null
          ? null
          : FloatingActionButton(onPressed: () => _nextStep(), child: Icon(Icons.navigate_next)),
      child: _buildChild(),
    );
  }

  Widget _buildChild() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 400),
      child: _finishedTest
          ? _buildFinishedTest()
          : _isGuessing
              ? _buildRadioOptions()
              : PresetVisualization(
                  initialFileId: _songIdentifiers[_currentStep],
                  showFilePicker: false,
                  showVibrationStatus: false,
                ),
    );
  }

  Widget _buildFinishedTest() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: smallGapSize,
        children: [
          Text('Congrats! You Finished the test!'),
          Text('Your score was: $_correctAnswers/$_count'),
          ElevatedButton(
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage())),
              child: Text('Try full app')),
        ],
      ),
    );
  }

  Widget _buildRadioOptions() {
    return Column(
      children: _shuffledOptions.mapToList(
        (option) => RadioListTile<String>(
          title: Text(option),
          value: option,
          groupValue: _currentlySelectedOption,
          onChanged: (value) => setState(() => _currentlySelectedOption = value),
        ),
      ),
    );
  }

  void _nextStep() {
    if (!_isGuessing) {
      setState(() => _isGuessing = true);
      _amplitudeVibrationService.pauseVibrating();
      return;
    }

    final correctAnswer = _songNames[_currentStep];
    final isCorrect = _currentlySelectedOption == correctAnswer;

    setState(() {
      _currentStep++;
      _isGuessing = false;
      _currentlySelectedOption = null;
      if (isCorrect) {
        _correctAnswers++;
      }
    });
  }
}
