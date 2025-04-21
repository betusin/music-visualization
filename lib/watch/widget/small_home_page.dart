import 'package:flutter/material.dart';
import 'package:vibration_poc/watch/widget/page_wrapper.dart';
import 'package:vibration_poc/watch/widget/pair_with_phone_page.dart';
import 'package:vibration_poc/watch/widget/settings_page.dart';

class SmallHomePage extends StatelessWidget {
  const SmallHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 10,
        children: [
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PairWithPhonePage()),
            ),
            child: const Text('Pair'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            ),
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }
}
