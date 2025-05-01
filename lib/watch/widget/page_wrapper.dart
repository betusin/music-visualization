import 'package:flutter/material.dart';
import 'package:vibration_poc/common/ui_constants.dart';
import 'package:vibration_poc/ioc/ioc_container.dart';
import 'package:vibration_poc/vibration/service/amplitude_vibration_service.dart';

class PageWrapper extends StatelessWidget {
  final _amplitudeVibrationService = get<AmplitudeVibrationService>();

  final Widget child;
  final String? title;
  final FloatingActionButton? floatingActionButton;

  PageWrapper({super.key, required this.child, this.title, this.floatingActionButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: _amplitudeVibrationService.hasVibrator ? null : _buildWarningContainer(context),
      appBar: title == null ? null : AppBar(title: Text(title!), centerTitle: false),
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: _amplitudeVibrationService.hasVibrator ? smallGapSize : largeGapSize),
          child: child,
        ),
      ),
    );
  }

  Widget _buildWarningContainer(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(16),
      color: colorScheme.errorContainer,
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: colorScheme.onErrorContainer, size: 32),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "This device does not support vibration.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: colorScheme.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }
}
