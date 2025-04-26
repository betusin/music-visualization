import 'package:flutter/material.dart';
import 'package:ui_kit/stream/widget/handling_stream_builder.dart';
import 'package:vibration_poc/common/ui_constants.dart';
import 'package:vibration_poc/ioc/ioc_container.dart';
import 'package:vibration_poc/pair/service/pairing_service.dart';
import 'package:vibration_poc/vibration/widget/vibration_observer.dart';
import 'package:vibration_poc/watch/widget/page_wrapper.dart';
import 'package:vibration_poc/watch/widget/pair_with_phone_page.dart';

class VibrationPage extends StatelessWidget {
  final _pairingService = get<PairingService>();

  VibrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      child: Center(
        child: HandlingStreamBuilder(
          stream: _pairingService.getPairLinksPerCurrentWatch,
          builder: (context, pairLinks) {
            if (pairLinks.isEmpty) {
              return _buildNoPair(context);
            }
            final deviceId = pairLinks.first.deviceId;
            return VibrationObserver(deviceId: deviceId);
          },
        ),
      ),
    );
  }

  Widget _buildNoPair(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: smallGapSize,
      children: [
        Text('No paired device'),
        ElevatedButton(onPressed: () => _navigateToPairPage(context), child: Text('Go to Pair page')),
      ],
    );
  }

  Future<dynamic> _navigateToPairPage(BuildContext context) =>
      Navigator.push(context, MaterialPageRoute(builder: (context) => PairWithPhonePage()));
}
