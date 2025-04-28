import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:vibration_poc/background_service/service/background_service_handler.dart';
import 'package:vibration_poc/common/ui_constants.dart';
import 'package:vibration_poc/ioc/ioc_container.dart';

class OnOffBackgroundButtons extends StatefulWidget {
  const OnOffBackgroundButtons({super.key});

  @override
  State<OnOffBackgroundButtons> createState() => _OnOffBackgroundButtonsState();
}

class _OnOffBackgroundButtonsState extends State<OnOffBackgroundButtons> {
  final BackgroundServiceHandler _backgroundServiceHandler = get<BackgroundServiceHandler>();
  // TODO(betka): this will not persist when app reopened
  bool isBackgroundServiceRunning = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: standardGapSize),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Recording in background'),
              Text('while the app is inactive'),
            ],
          ),
          _buildOnOffSwitch(),
        ],
      ),
    );
  }

  Widget _buildOnOffSwitch() {
    return FlutterSwitch(
      value: isBackgroundServiceRunning,
      onToggle: (value) {
        value ? _backgroundServiceHandler.startBackgroundService() : _backgroundServiceHandler.stopBackgroundService();
        setState(() => isBackgroundServiceRunning = value);
      },
      activeText: 'On',
      inactiveText: 'Off',
      showOnOff: true,
      activeColor: primaryColor,
    );
  }
}
