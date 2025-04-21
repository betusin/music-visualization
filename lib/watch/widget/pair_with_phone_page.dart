import 'package:flutter/material.dart';
import 'package:vibration_poc/watch/widget/page_wrapper.dart';

class PairWithPhonePage extends StatelessWidget {
  const PairWithPhonePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      child: Center(
        child: Text('This is the Pair With Phone Page'),
      ),
    );
  }
}
