import 'package:flutter/material.dart';
import 'package:vibration_poc/background_service/service/background_service_handler.dart';
import 'package:vibration_poc/ioc/ioc_container.dart';

class StartStopButtons extends StatelessWidget {
  final BackgroundServiceHandler _backgroundServiceHandler = get<BackgroundServiceHandler>();

  StartStopButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildBackgroundServiceButtons();
  }

  Widget _buildBackgroundServiceButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: _backgroundServiceHandler.startBackgroundService,
          child: const Text("Quit app and record in the background"),
        ),
        ElevatedButton(
          onPressed: _backgroundServiceHandler.stopBackgroundService,
          child: const Text("Stop recording in the background"),
        ),
      ],
    );
  }
}
