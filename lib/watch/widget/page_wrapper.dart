import 'package:flutter/material.dart';
import 'package:vibration_poc/common/ui_constants.dart';

class PageWrapper extends StatelessWidget {
  final Widget child;
  final String? title;

  const PageWrapper({super.key, required this.child, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title == null ? null : AppBar(title: Text(title!)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(smallGapSize),
          child: child,
        ),
      ),
    );
  }
}
