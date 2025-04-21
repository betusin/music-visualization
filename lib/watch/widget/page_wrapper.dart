import 'package:flutter/material.dart';
import 'package:vibration_poc/common/ui_constants.dart';

class PageWrapper extends StatelessWidget {
  final Widget child;

  const PageWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(smallGapSize),
          child: child,
        ),
      ),
    );
  }
}
