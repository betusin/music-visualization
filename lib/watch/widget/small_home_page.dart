import 'package:flutter/material.dart';
import 'package:vibration_poc/watch/widget/page_wrapper.dart';
import 'package:vibration_poc/watch/widget/pair_with_phone_page.dart';
import 'package:vibration_poc/watch/widget/settings_page.dart';

class SmallHomePage extends StatelessWidget {
  const SmallHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            ElevatedButton(
              onPressed: () => _navigateToPage(context, (context) => PairWithPhonePage()),
              child: const Text('Pair'),
            ),
            ElevatedButton(
              onPressed: () => _navigateToPage(context, (context) => SettingsPage()),
              child: const Text('Settings'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPage(BuildContext context, WidgetBuilder builder) {
    Navigator.push(context, MaterialPageRoute(builder: builder));
  }
}
