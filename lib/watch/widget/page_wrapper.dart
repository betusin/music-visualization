import 'package:flutter/material.dart';
import 'package:master_kit/sdk_extension/iterable/iterable_extension.dart';
import 'package:vibration_poc/common/ui_constants.dart';
import 'package:vibration_poc/ioc/ioc_container.dart';
import 'package:vibration_poc/vibration/service/amplitude_vibration_service.dart';

class PageWrapper extends StatelessWidget {
  final _amplitudeVibrationService = get<AmplitudeVibrationService>();

  final Widget child;
  final List<Widget>? actions;
  final String? title;
  final FloatingActionButton? floatingActionButton;
  final BottomNavigationBar? bottomNavigationBar;

  PageWrapper({
    super.key,
    required this.child,
    this.title,
    this.floatingActionButton,
    this.actions,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    final shouldNotBuildAppBar = title == null && actions.isNullOrEmpty;

    return Scaffold(
      bottomSheet: _amplitudeVibrationService.hasVibrator ? null : _buildWarningContainer(context),
      appBar: shouldNotBuildAppBar ? null : AppBar(title: Text(title!), centerTitle: false, actions: actions),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: SafeArea(
        child: Padding(
          padding:
              _amplitudeVibrationService.hasVibrator ? EdgeInsets.zero : EdgeInsets.symmetric(vertical: largeGapSize),
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
