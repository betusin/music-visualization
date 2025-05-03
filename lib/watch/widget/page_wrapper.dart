import 'package:flutter/material.dart';
import 'package:master_kit/sdk_extension/iterable/iterable_extension.dart';
import 'package:vibration_poc/common/ui_constants.dart';

class PageWrapper extends StatelessWidget {
  final Widget child;
  final List<Widget>? actions;
  final String? title;
  final FloatingActionButton? floatingActionButton;
  final BottomNavigationBar? bottomNavigationBar;

  const PageWrapper({
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

    final isWatch = MediaQuery.of(context).size.height < watchSize;

    return Scaffold(
      appBar: shouldNotBuildAppBar ? null : AppBar(title: Text(title!), centerTitle: false, actions: actions),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: SafeArea(
        child: Padding(
          padding: isWatch ? EdgeInsets.symmetric(vertical: largeGapSize) : EdgeInsets.zero,
          child: child,
        ),
      ),
    );
  }
}
