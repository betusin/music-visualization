import 'package:flutter/material.dart';
import 'package:vibration_poc/common/ui_constants.dart';
import 'package:vibration_poc/watch/widget/page_wrapper.dart';
import 'package:vibration_poc/watch/widget/pair_with_phone_page.dart';
import 'package:vibration_poc/watch/widget/vibration_page.dart';

class SmallHomePage extends StatelessWidget {
  const SmallHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: smallGapSize,
          children: [
            _buildButton(context, 'Pair', Icons.link, (_) => PairWithPhonePage()),
            _buildButton(context, 'Vibrate', Icons.vibration, (_) => VibrationPage()),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label, IconData icon, WidgetBuilder pageBuilder) {
    return ElevatedButton.icon(
      onPressed: () => _navigateToPage(context, pageBuilder),
      label: Text(label),
      icon: Icon(icon),
    );
  }

  void _navigateToPage(BuildContext context, WidgetBuilder builder) {
    Navigator.push(context, MaterialPageRoute(builder: builder));
  }
}
