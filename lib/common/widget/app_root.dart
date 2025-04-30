import 'package:flutter/material.dart';
import 'package:ui_kit/stream/widget/handling_stream_builder.dart';
import 'package:vibration_poc/common/ui_constants.dart';
import 'package:vibration_poc/common/widget/main_page.dart';
import 'package:vibration_poc/common/widget/test_page.dart';
import 'package:vibration_poc/ioc/ioc_container.dart';
import 'package:vibration_poc/song_picking_test/service/test_mode_controller.dart';
import 'package:vibration_poc/watch/widget/small_home_page.dart';

class AppRoot extends StatelessWidget {
  final _testModeController = get<TestModeController>();

  AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: _isWatch(context) ? SmallHomePage() : _buildMainPage(),
    );
  }

  bool _isWatch(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // TODO(betka): use this instead of guessing min height? (watchShape is part of wear package and the build fails with that)
    // final watch = WatchShape.of(context);
    return size.height < 210;
  }

  Widget _buildMainPage() {
    return HandlingStreamBuilder(
      stream: _testModeController.testModeOnStream,
      builder: (_, isInTestMode) => isInTestMode ? TestPage() : MainPage(),
    );
  }
}
