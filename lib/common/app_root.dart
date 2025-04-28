import 'package:flutter/material.dart';
import 'package:vibration_poc/common/ui_constants.dart';
import 'package:vibration_poc/home_page.dart';
import 'package:vibration_poc/watch/widget/small_home_page.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

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
      home: _isWatch(context) ? SmallHomePage() : HomePage(),
    );
  }

  bool _isWatch(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // TODO(betka): use this instead of guessing min height? (watchShape is part of wear package and the build fails with that)
    // final watch = WatchShape.of(context);
    return size.height < 210;
  }
}
