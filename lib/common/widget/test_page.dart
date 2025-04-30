import 'package:flutter/material.dart';
import 'package:vibration_poc/common/ui_constants.dart';
import 'package:vibration_poc/ioc/ioc_container.dart';
import 'package:vibration_poc/pair/widget/pair_page.dart';
import 'package:vibration_poc/song_picking_test/service/test_mode_controller.dart';
import 'package:vibration_poc/song_picking_test/widget/stepped_task_page.dart';
import 'package:vibration_poc/watch/widget/page_wrapper.dart';

class TestPage extends StatelessWidget {
  final _testModeController = get<TestModeController>();

  TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final thirdOfHeight = MediaQuery.of(context).size.height / 3;
    return PageWrapper(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              spacing: standardGapSize,
              children: [
                SizedBox(width: thirdOfHeight, height: thirdOfHeight),
                ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PairPage())),
                  child: Text('Pair with watch'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SteppedTaskPage())),
                  child: Text('Begin testing'),
                ),
              ],
            ),
            TextButton(onPressed: () => _testModeController.finishTestMode(), child: Text('Skip Test')),
          ],
        ),
      ),
    );
  }
}
