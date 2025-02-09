import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class VibrationAdjustments extends StatefulWidget {
  const VibrationAdjustments({
    super.key,
  });

  @override
  State<VibrationAdjustments> createState() => _VibrationAdjustmentsState();
}

class _VibrationAdjustmentsState extends State<VibrationAdjustments> {
  int _amplitude = 0;
  int _durationInMs = 500;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: Slider(
            value: _amplitude.toDouble(),
            onChanged: (value) => setState(() => _amplitude = value.toInt()),
            min: 0,
            max: 255,
            label: '$_amplitude',
          ),
        ),
        Flexible(
          child: Slider(
            value: _durationInMs.toDouble(),
            onChanged: (value) => setState(() => _durationInMs = value.toInt()),
            min: 0,
            max: 50000,
            label: '$_durationInMs',
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // TODO(betka): one primary, one secondary btn
            ElevatedButton(
              onPressed: () => Vibration.vibrate(
                // duration: _durationInMs,
                amplitude: _amplitude,
              ),
              child: Text('Start Vibration'),
            ),
            // TODO(betka): stop does not work if set with specific duration
            ElevatedButton(onPressed: () => Vibration.cancel, child: Text('Stop Vibration')),
          ],
        ),
      ],
    );
  }
}
